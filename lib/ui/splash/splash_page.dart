import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_assets.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/services/biometric/biometric_service.dart';
import 'package:fintrack/core/services/storage/preferences_service.dart';
import 'package:fintrack/l10n/app_localizations.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _authFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final prefs = ref.read(preferencesServiceProvider);
    final bio = ref.read(biometricServiceProvider);
    if (prefs.isBiometricEnabled()) {
      final ok = await bio.authenticate();
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      } else {
        setState(() => _authFailed = true);
      }
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    }
  }

  Future<void> _retry() async {
    setState(() => _authFailed = false);
    final ok = await ref.read(biometricServiceProvider).authenticate();
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    } else {
      setState(() => _authFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.splashLogo,
                width: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.account_balance_wallet,
                  size: 96,
                  color: AppColors.accentDark,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.splashTagline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMutedDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
              if (_authFailed) ...[
                const SizedBox(height: 32),
                Text(
                  l10n.authRequired,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textMutedDark),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _retry,
                  child: Text(l10n.retry),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
