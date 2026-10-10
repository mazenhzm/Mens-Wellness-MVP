import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mens_wellness_mobile/core/api/api_client.dart';
import 'package:mens_wellness_mobile/core/auth/secure_clerk_persistor.dart';
import 'package:mens_wellness_mobile/core/config/app_config.dart';
import 'package:mens_wellness_mobile/core/l10n/app_localizations.dart';
import 'package:mens_wellness_mobile/core/providers.dart';
import 'package:mens_wellness_mobile/core/theme/app_theme.dart';
import 'package:mens_wellness_mobile/features/account/account_home.dart';
import 'package:mens_wellness_mobile/features/auth/auth_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment();

  try {
    config.validate();
    runApp(WellnessApp(config: config));
  } on AppConfigurationException {
    runApp(const MissingConfigurationApp());
  }
}

class WellnessApp extends StatefulWidget {
  const WellnessApp({super.key, required this.config});

  final AppConfig config;

  @override
  State<WellnessApp> createState() => _WellnessAppState();
}

class _WellnessAppState extends State<WellnessApp> {
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => ClerkAuthBuilder(
          signedInBuilder: (context, authState) =>
              _authenticatedHome(authState),
          signedOutBuilder: (context, authState) => const WelcomeScreen(),
        ),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => ClerkAuthBuilder(
          signedInBuilder: (context, authState) =>
              _authenticatedHome(authState),
          signedOutBuilder: (context, authState) =>
              const AuthenticationScreen(),
        ),
      ),
    ],
  );

  Widget _authenticatedHome(ClerkAuthState authState) {
    final apiClient = ApiClient(
      baseUri: widget.config.apiBaseUri,
      tokenSource: ClerkAccessTokenSource(authState),
      onUnauthorized: authState.signOut,
    );

    return ProviderScope(
      overrides: [apiClientProvider.overrideWithValue(apiClient)],
      child: AccountHome(authState: authState),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clerkConfig = ClerkAuthConfig(
      publishableKey: widget.config.clerkPublishableKey,
      persistor: SecureClerkPersistor(),
      telemetryPeriod: Duration.zero,
    );

    return ProviderScope(
      child: ClerkAuth(
        config: clerkConfig,
        child: MaterialApp.router(
          title: 'Wellbeing',
          theme: AppTheme.light,
          routerConfig: _router,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}

class MissingConfigurationApp extends StatelessWidget {
  const MissingConfigurationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellbeing',
      theme: AppTheme.light,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          final strings = AppLocalizations.of(context);
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.settings_outlined, size: 48),
                      const SizedBox(height: 20),
                      Text(
                        strings.configurationTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        strings.configurationBody,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
