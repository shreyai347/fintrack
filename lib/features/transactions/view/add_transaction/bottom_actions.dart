import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';

import '../../viewmodel/transaction_provider.dart';

class AddTransactionBottomActions extends ConsumerWidget {
  const AddTransactionBottomActions({
    super.key,
    required this.dark,
    required this.onSave,
  });

  final bool dark;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = ref.watch(addTransactionWizardProvider);
    final notifier = ref.read(addTransactionWizardProvider.notifier);
    final categoriesAsync = ref.watch(categoriesProvider);
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final step = w.currentStep;
    final last = AddTransactionWizardNotifier.lastStepIndex(w.isExpense);

    final bool nextEnabled;
    final String nextLabel;
    final VoidCallback? onPrimary;
    if (step == 0) {
      final catsReady = categoriesAsync.hasValue;
      nextEnabled = w.parsedAmount > 0 && (w.isExpense || catsReady);
      nextLabel = 'Next →';
      onPrimary = nextEnabled
          ? () {
              final catsList = categoriesAsync.asData?.value;
              final ok = notifier.advanceFromAmount(categories: catsList);
              if (!ok && !w.isExpense && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.transactionsSalaryMissing)),
                );
              }
            }
          : null;
    } else if (step == 1 && w.isExpense) {
      nextEnabled = w.selectedCategoryId != null;
      nextLabel = 'Next →';
      onPrimary = nextEnabled ? notifier.advanceStep : null;
    } else if (step < last) {
      nextEnabled = true;
      nextLabel = 'Next →';
      onPrimary = notifier.advanceStep;
    } else if (step == last) {
      nextEnabled = true;
      nextLabel = 'Save ✓';
      onPrimary = onSave;
    } else {
      nextEnabled = false;
      nextLabel = 'Next →';
      onPrimary = null;
    }

    Widget primaryButton() {
      return Material(
        color: nextEnabled
            ? accent
            : (dark ? AppColors.inputDark : AppColors.inputLight),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPrimary,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(
              nextLabel,
              style: TextStyle(
                color: nextEnabled ? AppColors.onVivid : muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    if (step == 0) {
      return primaryButton();
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: muted,
              side: BorderSide(color: border),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: notifier.prevStep,
            child: const Text('← Back'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: primaryButton()),
      ],
    );
  }
}
