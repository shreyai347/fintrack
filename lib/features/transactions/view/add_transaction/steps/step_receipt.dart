import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/utils/date_formatter.dart';

import '../../../viewmodel/transaction_provider.dart';
import '../add_transaction_utils.dart';
import '../receipt_widgets.dart';
import '../step_scroll.dart';

class AddTransactionStepReceipt extends ConsumerWidget {
  const AddTransactionStepReceipt({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = ref.watch(addTransactionWizardProvider);
    final notifier = ref.read(addTransactionWizardProvider.notifier);
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;
    final border =
        dark ? AppColors.borderDark : AppColors.borderLight;
    final cats = ref.watch(categoriesProvider);
    final catName = cats.when(
      data: (l) => categoryById(l, w.selectedCategoryId)?.name ?? '—',
      loading: () => '—',
      error: (_, _) => '—',
    );

    return AddTransactionStepScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Text(
                CurrencyFormatter.format(w.parsedAmount),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '$catName · ${DateFormatter.formatDisplay(w.selectedDate)}',
                style: TextStyle(fontSize: 13, color: hint),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Receipt photo', style: TextStyle(fontSize: 13, color: hint)),
          const SizedBox(height: 10),
          if (w.receiptPath == null)
            ReceiptCapturePlaceholder(
              dark: dark,
              onTap: () async {
                final path = await Navigator.of(context).pushNamed<String?>(
                  AppRoutes.receiptCamera,
                );
                if (path != null) notifier.setReceiptPath(path);
              },
            )
          else
            ReceiptAttachedPreview(
              path: w.receiptPath!,
              onClear: () => notifier.setReceiptPath(null),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Divider(color: border, thickness: 0.5)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'or skip this step',
                  style: TextStyle(fontSize: 13, color: hint),
                ),
              ),
              Expanded(child: Divider(color: border, thickness: 0.5)),
            ],
          ),
        ],
      ),
    );
  }
}
