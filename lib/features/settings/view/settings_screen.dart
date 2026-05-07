import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/config/locale_notifier.dart';
import 'package:fintrack/core/config/theme_mode_notifier.dart';
import 'package:fintrack/core/config/user_display_name_notifier.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/services/biometric/biometric_service.dart';
import 'package:fintrack/core/services/storage/preferences_service.dart';
import 'package:fintrack/features/budget/repository/budget_repository_impl.dart';
import 'package:fintrack/features/transactions/repository/transaction_repository_impl.dart';
import 'package:fintrack/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _bioLoading = true;
  bool? _bioAvailable;
  bool _bioEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBiometric());
  }

  Future<void> _loadBiometric() async {
    final prefs = ref.read(preferencesServiceProvider);
    final enabled = prefs.isBiometricEnabled();
    final available = await ref.read(biometricServiceProvider).isAvailable();
    if (!mounted) return;
    setState(() {
      _bioEnabled = enabled;
      _bioAvailable = available;
      _bioLoading = false;
    });
  }

  Color _accent(bool dark) =>
      dark ? AppColors.accentDark : AppColors.accentLight;

  Color _iconColor(bool dark) => _accent(dark);

  Widget _sectionHeader(String text, bool dark) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8, top: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.9,
          color: _accent(dark).withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _settingsCard({
    required bool dark,
    required List<Widget> children,
  }) {
    final bg = dark ? AppColors.cardDark : AppColors.cardLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  Widget _divider(bool dark) => Divider(
        height: 1,
        thickness: 1,
        color: dark ? AppColors.dividerDark : AppColors.dividerLight,
      );

  String _themeSubtitle(AppLocalizations l10n) {
    switch (ref.watch(themeModeNotifierProvider)) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  String _languageSubtitle() {
    final code = ref.watch(localeNotifierProvider)?.languageCode ?? 'en';
    return code == 'hi' ? 'हिन्दी' : 'English';
  }

  Future<void> _pickTheme(BuildContext context, AppLocalizations l10n) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.themeLight),
                onTap: () => Navigator.pop(ctx, 'light'),
              ),
              ListTile(
                title: Text(l10n.themeDark),
                onTap: () => Navigator.pop(ctx, 'dark'),
              ),
              ListTile(
                title: Text(l10n.themeSystem),
                onTap: () => Navigator.pop(ctx, 'system'),
              ),
            ],
          ),
        );
      },
    );
    if (choice == null || !context.mounted) return;
    await ref.read(themeModeNotifierProvider.notifier).setThemeModePreference(
          choice,
        );
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () => Navigator.pop(ctx, 'en'),
              ),
              ListTile(
                title: const Text('हिन्दी'),
                onTap: () => Navigator.pop(ctx, 'hi'),
              ),
            ],
          ),
        );
      },
    );
    if (choice == null || !context.mounted) return;
    await ref.read(localeNotifierProvider.notifier).setLanguageCode(choice);
  }

  Future<void> _onBiometricChanged(bool on, AppLocalizations l10n) async {
    final prefs = ref.read(preferencesServiceProvider);
    final bio = ref.read(biometricServiceProvider);
    if (on) {
      final ok = await bio.authenticate();
      if (!mounted) return;
      if (ok) {
        await prefs.setBiometricEnabled(true);
        setState(() => _bioEnabled = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.authenticationFailed)),
        );
      }
    } else {
      await prefs.setBiometricEnabled(false);
      setState(() => _bioEnabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayName = ref.watch(userDisplayNameNotifierProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final titleColor =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final accent = _accent(dark);
    final chevron = dark ? AppColors.textHintDark : AppColors.textHintLight;

    final switchTheme = SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.onVivid;
        }
        return muted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent.withValues(alpha: 0.45);
        }
        return (dark ? AppColors.borderDark : AppColors.borderLight)
            .withValues(alpha: 0.6);
      }),
      trackOutlineColor: WidgetStateProperty.all(
        dark ? AppColors.borderDark : AppColors.borderLight,
      ),
    );

    final bottomInset =
        MediaQuery.paddingOf(context).bottom + MediaQuery.viewPaddingOf(context).bottom;
    const navOverlap = 96.0;

    return ColoredBox(
      color: bg,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 24 + bottomInset + navOverlap),
        children: [
          _sectionHeader(l10n.profileSection, dark),
          _settingsCard(
            dark: dark,
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(Icons.badge_outlined, color: _iconColor(dark)),
                title: Text(
                  l10n.yourName,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  displayName.isEmpty ? l10n.nameNotSetHint : displayName,
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: Icon(Icons.chevron_right, color: chevron),
                onTap: () async {
                  final controller = TextEditingController(text: displayName);
                  final saved = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.yourName),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'What should we call you?',
                        ),
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n.cancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.save),
                        ),
                      ],
                    ),
                  );
                  if (saved == true && context.mounted) {
                    await ref
                        .read(userDisplayNameNotifierProvider.notifier)
                        .setName(controller.text);
                  }
                },
              ),
            ],
          ),
          _sectionHeader(l10n.security, dark),
          _settingsCard(
            dark: dark,
            children: [
              if (_bioLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accent,
                      ),
                    ),
                  ),
                )
              else
                Theme(
                  data: Theme.of(context).copyWith(switchTheme: switchTheme),
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    secondary: Icon(Icons.fingerprint, color: _iconColor(dark)),
                    title: Text(
                      l10n.biometricLock,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      _bioAvailable == false
                          ? l10n.biometricUnavailable
                          : l10n.biometricLockSubtitle,
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                    value: _bioEnabled && (_bioAvailable == true),
                    onChanged: _bioAvailable != true
                        ? null
                        : (v) => _onBiometricChanged(v, l10n),
                  ),
                ),
            ],
          ),
          _sectionHeader(l10n.appearance, dark),
          _settingsCard(
            dark: dark,
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading:
                    Icon(Icons.palette_outlined, color: _iconColor(dark)),
                title: Text(
                  l10n.theme,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  _themeSubtitle(l10n),
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: Icon(Icons.chevron_right, color: chevron),
                onTap: () => _pickTheme(context, l10n),
              ),
              _divider(dark),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: Icon(Icons.language, color: _iconColor(dark)),
                title: Text(
                  l10n.language,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  _languageSubtitle(),
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: Icon(Icons.chevron_right, color: chevron),
                onTap: () => _pickLanguage(context),
              ),
            ],
          ),
          _sectionHeader(l10n.dataSection, dark),
          _settingsCard(
            dark: dark,
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading:
                    Icon(Icons.ios_share_outlined, color: _iconColor(dark)),
                title: Text(
                  l10n.exportData,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.exportDataSubtitle,
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: Icon(Icons.chevron_right, color: chevron),
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.export),
              ),
              _divider(dark),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading:
                    Icon(Icons.cloud_sync_outlined, color: _iconColor(dark)),
                title: Text(
                  l10n.backupRestore,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.backupRestoreSubtitle,
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: Icon(Icons.chevron_right, color: chevron),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.comingSoon)),
                  );
                },
              ),
              _divider(dark),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: const Icon(
                  Icons.delete_forever_outlined,
                  color: AppColors.error,
                ),
                title: Text(
                  l10n.clearAllData,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  l10n.clearAllDataSubtitle,
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: Icon(Icons.chevron_right, color: chevron),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.clearDataConfirmTitle),
                      content: Text(l10n.clearDataConfirmBody),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n.cancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.delete),
                        ),
                      ],
                    ),
                  );
                  if (confirm != true || !context.mounted) return;
                  final ok =
                      await ref.read(biometricServiceProvider).authenticate();
                  if (!context.mounted) return;
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.authenticationFailed)),
                    );
                    return;
                  }
                  await ref
                      .read(transactionRepositoryProvider)
                      .deleteAllTransactionsAndRecurringRules();
                  await ref
                      .read(budgetRepositoryProvider)
                      .clearAllBudgetsAndReseedCurrentMonth();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.dataCleared)),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
