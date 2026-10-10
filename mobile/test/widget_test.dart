import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mens_wellness_mobile/core/api/api_client.dart';
import 'package:mens_wellness_mobile/core/config/app_config.dart';
import 'package:mens_wellness_mobile/core/l10n/app_localizations.dart';

void main() {
  group('AppConfig', () {
    test('normalizes the API base path', () {
      const config = AppConfig(
        apiBaseUrl: 'https://api.example.test/api',
        clerkPublishableKey: 'pk_test_public',
      );

      config.validate();
      expect(config.apiBaseUri.toString(), 'https://api.example.test/api/');
    });

    test('rejects non-HTTPS API endpoints', () {
      const config = AppConfig(
        apiBaseUrl: 'http://api.example.test/api/',
        clerkPublishableKey: 'pk_test_public',
      );

      expect(config.validate, throwsA(isA<AppConfigurationException>()));
    });
  });

  group('ApiClient', () {
    test('adds a session bearer token to authenticated requests', () async {
      final adapter = _RecordingAdapter();
      final client = ApiClient(
        baseUri: Uri.parse('https://api.example.test/api/'),
        tokenSource: _FakeTokenSource('short-lived-session-token'),
        onUnauthorized: null,
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/'))
          ..httpClientAdapter = adapter,
      );

      await client.get<Map<String, dynamic>>('profile');
      expect(
        adapter.lastRequest?.headers['Authorization'],
        'Bearer short-lived-session-token',
      );
    });

    test(
      'does not send a session token to the public health endpoint',
      () async {
        final adapter = _RecordingAdapter();
        final client = ApiClient(
          baseUri: Uri.parse('https://api.example.test/api/'),
          tokenSource: _FakeTokenSource('short-lived-session-token'),
          onUnauthorized: null,
          dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/'))
            ..httpClientAdapter = adapter,
        );

        expect(await client.checkHealth(), isTrue);
        expect(
          adapter.lastRequest?.headers.containsKey('Authorization'),
          isFalse,
        );
        expect(adapter.lastRequest?.uri.path, '/api/healthz');
      },
    );
  });

  testWidgets('Arabic strings and RTL direction are available', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) => Text(
            '${AppLocalizations.of(context).welcomeTitle}|'
            '${Directionality.of(context)}',
          ),
        ),
      ),
    );

    expect(find.text('مساحة خاصة لرفاهيتك.|TextDirection.rtl'), findsOneWidget);
  });
}

class _FakeTokenSource implements AccessTokenSource {
  const _FakeTokenSource(this.token);

  final String? token;

  @override
  Future<String?> getAccessToken() async => token;
}

class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{"status":"ok"}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
