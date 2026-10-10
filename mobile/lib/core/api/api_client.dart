import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:dio/dio.dart';

abstract interface class AccessTokenSource {
  Future<String?> getAccessToken();
}

class ClerkAccessTokenSource implements AccessTokenSource {
  ClerkAccessTokenSource(this._authState);

  final ClerkAuthState _authState;

  @override
  Future<String?> getAccessToken() async {
    if (_authState.user == null) return null;
    return (await _authState.sessionToken()).jwt;
  }
}

class ApiClient {
  ApiClient({
    required Uri baseUri,
    required AccessTokenSource tokenSource,
    required Future<void> Function()? onUnauthorized,
    Dio? dio,
  }) : _tokenSource = tokenSource,
       _onUnauthorized = onUnauthorized,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUri.toString(),
               connectTimeout: const Duration(seconds: 10),
               receiveTimeout: const Duration(seconds: 15),
               sendTimeout: const Duration(seconds: 15),
               headers: const {'Accept': 'application/json'},
               responseType: ResponseType.json,
             ),
           ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra[_skipAuthenticationKey] == true) {
            handler.next(options);
            return;
          }

          try {
            final token = await _tokenSource.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          } on Object {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.unknown,
                message: 'Could not establish a secure session.',
              ),
            );
          }
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              await _onUnauthorized?.call();
            } on Object {
              // Preserve the original safe API error if local sign-out fails.
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  static const _skipAuthenticationKey = 'skipAuthentication';

  final AccessTokenSource _tokenSource;
  final Future<void> Function()? _onUnauthorized;
  final Dio _dio;

  Future<T?> get<T>(String path, {bool authenticated = true}) async {
    try {
      final response = await _dio.get<T>(
        path,
        options: Options(extra: {_skipAuthenticationKey: !authenticated}),
      );
      return response.data;
    } on DioException catch (error) {
      throw ApiFailure.fromDio(error);
    }
  }

  Future<bool> checkHealth() async {
    try {
      final result = await get<Map<String, dynamic>>(
        'healthz',
        authenticated: false,
      );
      return result?['status'] == 'ok';
    } on ApiFailure {
      return false;
    }
  }

  Future<bool> checkSession() async {
    try {
      final result = await get<Map<String, dynamic>>('v1/session');
      return result?['authenticated'] == true && result?['user_id'] is String;
    } on ApiFailure {
      return false;
    }
  }
}

class ApiFailure implements Exception {
  const ApiFailure(this.statusCode, this.message);

  factory ApiFailure.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = switch (statusCode) {
      401 => 'Your session ended. Sign in again to continue.',
      int code when code >= 500 => 'The service is temporarily unavailable.',
      _ => 'The request could not be completed.',
    };
    return ApiFailure(statusCode, message);
  }

  final int? statusCode;
  final String message;

  @override
  String toString() => message;
}
