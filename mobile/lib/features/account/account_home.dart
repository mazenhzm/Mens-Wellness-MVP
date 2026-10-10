import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mens_wellness_mobile/core/l10n/app_localizations.dart';
import 'package:mens_wellness_mobile/core/providers.dart';

class AccountHome extends ConsumerStatefulWidget {
  const AccountHome({super.key, required this.authState});

  final ClerkAuthState authState;

  @override
  ConsumerState<AccountHome> createState() => _AccountHomeState();
}

class _AccountHomeState extends ConsumerState<AccountHome> {
  bool _isChecking = false;
  bool? _isServiceAvailable;
  bool? _isSessionVerified;

  Future<void> _checkConnection() async {
    setState(() {
      _isChecking = true;
      _isServiceAvailable = null;
      _isSessionVerified = null;
    });
    final api = ref.read(apiClientProvider);
    final results = await Future.wait([api.checkHealth(), api.checkSession()]);
    if (!mounted) return;
    setState(() {
      _isChecking = false;
      _isServiceAvailable = results[0];
      _isSessionVerified = results[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appName),
        actions: [
          TextButton.icon(
            onPressed: widget.authState.signOut,
            icon: const Icon(Icons.logout, size: 18),
            label: Text(strings.signOut),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              children: [
                Container(
                  height: 148,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1B756A), Color(0xFF24565A)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.health_and_safety_outlined,
                      color: Colors.white,
                      size: 54,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  strings.accountTitle,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(strings.accountBody, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 28),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.serviceStatus,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        _StatusRow(
                          label: strings.serviceStatus,
                          value: _isServiceAvailable == null
                              ? strings.connectionNotChecked
                              : _isServiceAvailable!
                              ? strings.connectionReady
                              : strings.connectionUnavailable,
                          isReady: _isServiceAvailable,
                        ),
                        const SizedBox(height: 12),
                        _StatusRow(
                          label: strings.sessionStatus,
                          value: _isSessionVerified == null
                              ? strings.connectionNotChecked
                              : _isSessionVerified!
                              ? strings.sessionVerified
                              : strings.sessionUnavailable,
                          isReady: _isSessionVerified,
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _isChecking ? null : _checkConnection,
                            child: _isChecking
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(strings.checkConnection),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  strings.privacyNote,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
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

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.value,
    required this.isReady,
  });

  final String label;
  final String value;
  final bool? isReady;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          isReady == true
              ? Icons.check_circle_outline
              : isReady == false
              ? Icons.error_outline
              : Icons.circle_outlined,
          color: isReady == true
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelLarge),
              Text(value, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
