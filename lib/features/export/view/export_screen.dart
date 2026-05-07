import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_assets.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/features/export/view/widgets/export_button.dart';
import 'package:fintrack/features/export/viewmodel/export_notifier.dart';

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(exportNotifierProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;

    ref.listen<ExportState>(exportNotifierProvider, (prev, next) {
      if (next is ExportSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exportReady)),
        );
      } else if (next is ExportError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
        ref.read(exportNotifierProvider.notifier).reset();
      }
    });

    bool loading(String k) {
      final s = state;
      return s is ExportLoading && s.kind == k;
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            AppAssets.splashLogo,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.account_balance_wallet_rounded),
          ),
        ),
        leadingWidth: 48,
        title: Text(l10n.navExport),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ExportButton(
            label: l10n.exportAsCSV,
            subtitle: l10n.excelSheets,
            icon: Icons.description_outlined,
            isLoading: loading('csv'),
            onTap: () =>
                ref.read(exportNotifierProvider.notifier).exportCsv(),
          ),
          const SizedBox(height: 12),
          ExportButton(
            label: l10n.exportAsJSON,
            subtitle: l10n.fullBackup,
            icon: Icons.data_object,
            isLoading: loading('json'),
            onTap: () =>
                ref.read(exportNotifierProvider.notifier).exportJson(),
          ),
          const SizedBox(height: 12),
          ExportButton(
            label: l10n.qrSummary,
            subtitle: l10n.quickShare,
            icon: Icons.qr_code_2,
            isLoading: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.backupComingSoon)),
              );
            },
          ),
        ],
      ),
    );
  }
}
