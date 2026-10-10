class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.clerkPublishableKey,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment('API_BASE_URL'),
      clerkPublishableKey: String.fromEnvironment('CLERK_PUBLISHABLE_KEY'),
    );
  }

  final String apiBaseUrl;
  final String clerkPublishableKey;

  Uri get apiBaseUri {
    final value = apiBaseUrl.trim();
    if (value.isEmpty) {
      throw const AppConfigurationException('API_BASE_URL is required.');
    }

    final parsed = Uri.tryParse(value);
    if (parsed == null ||
        parsed.host.isEmpty ||
        parsed.userInfo.isNotEmpty ||
        parsed.hasQuery ||
        parsed.hasFragment ||
        parsed.scheme != 'https') {
      throw const AppConfigurationException(
        'API_BASE_URL must be an HTTPS URL without credentials, query, or fragment.',
      );
    }

    final path = parsed.path.endsWith('/') ? parsed.path : '${parsed.path}/';
    return parsed.replace(path: path);
  }

  void validate() {
    apiBaseUri;
    if (clerkPublishableKey.trim().isEmpty) {
      throw const AppConfigurationException(
        'CLERK_PUBLISHABLE_KEY is required.',
      );
    }
  }
}

class AppConfigurationException implements Exception {
  const AppConfigurationException(this.message);

  final String message;

  @override
  String toString() => message;
}
