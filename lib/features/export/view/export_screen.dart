import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/features/export/view/widgets/export_button.dart';
import 'package:fintrack/features/export/view/widgets/qr_share_widget.dart';
import 'package:fintrack/features/export/viewmodel/export_notifier.dart';
import 'package:fintrack/features/transactions/repository/category_repository_impl.dart';
import 'package:fintrack/features/transactions/repository/transaction_repository_impl.dart';

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exportNotifierProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;

    ref.listen<ExportState>(exportNotifierProvider, (prev, next) {
      if (next is ExportSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.exportReady)),
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
        title: Text(AppStrings.navExport),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ExportButton(
            label: AppStrings.exportAsCSV,
            subtitle: AppStrings.excelSheets,
            icon: Icons.description_outlined,
            isLoading: loading('csv'),
            onTap: () =>
                ref.read(exportNotifierProvider.notifier).exportCsv(),
          ),
          const SizedBox(height: 12),
          ExportButton(
            label: AppStrings.exportAsJSON,
            subtitle: AppStrings.fullBackup,
            icon: Icons.data_object,
            isLoading: loading('json'),
            onTap: () =>
                ref.read(exportNotifierProvider.notifier).exportJson(),
          ),
          const SizedBox(height: 12),
          ExportButton(
            label: AppStrings.qrSummary,
            subtitle: AppStrings.quickShare,
            icon: Icons.qr_code_2,
            isLoading: false,
            onTap: () async {
              final txs =
                  await ref.read(transactionRepositoryProvider).getAll();
              final cats =
                  await ref.read(categoryRepositoryProvider).getAll();
              final data = ref
                  .read(exportNotifierProvider.notifier)
                  .generateQrData(txs, cats);
              if (!context.mounted) return;
              await showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => QrShareWidget(qrData: data),
              );
            },
          ),
        ],
      ),
    );
  }
}
