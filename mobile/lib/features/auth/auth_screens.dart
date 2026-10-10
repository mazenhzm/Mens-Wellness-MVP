import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mens_wellness_mobile/core/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BrandMark(label: strings.appName),
                  const Spacer(),
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Icon(
                      Icons.spa_outlined,
                      size: 34,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    strings.welcomeTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    strings.welcomeBody,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.go('/auth'),
                      child: Text(strings.continueToAccount),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      strings.privacyNote,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF718287),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                Text(
                  strings.authTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  strings.authBody,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 26),
                const ClerkAuthentication(),
                const SizedBox(height: 24),
                Text(
                  strings.privacyNote,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF718287),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.health_and_safety_outlined,
            color: Colors.white,
            size: 21,
          ),
        ),
        const SizedBox(width: 11),
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
