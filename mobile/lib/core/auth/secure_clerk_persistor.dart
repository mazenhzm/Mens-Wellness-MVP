import 'dart:convert';

import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores Clerk session state using Android Keystore/iOS Keychain-backed storage.
class SecureClerkPersistor implements clerk.Persistor {
  SecureClerkPersistor({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> initialize() async {}

  @override
  void terminate() {}

  @override
  Future<T?> read<T>(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;

    try {
      final decoded = jsonDecode(value);
      return decoded is T ? decoded : null;
    } on FormatException {
      await delete(key);
      return null;
    }
  }

  @override
  Future<void> write<T>(String key, T value) {
    return _storage.write(key: key, value: jsonEncode(value));
  }

  @override
  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }
}
