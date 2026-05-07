import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
      nextLabel = l10n.next;
      onPrimary = nextEnabled
          ? () {
              final catsList = categoriesAsync.asData?.value;
              final ok = notifier.advanceFromAmount(categories: catsList);
              if (!ok && !w.isExpense && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.transactionsSalaryMissing)),
                );
              }
            }
          : null;
    } else if (step == 1 && w.isExpense) {
      nextEnabled = w.selectedCategoryId != null;
      nextLabel = l10n.next;
      onPrimary = nextEnabled ? notifier.advanceStep : null;
    } else if (step < last) {
      nextEnabled = true;
      nextLabel = l10n.next;
      onPrimary = notifier.advanceStep;
    } else if (step == last) {
      nextEnabled = true;
      nextLabel = l10n.saveTransaction;
      onPrimary = onSave;
    } else {
      nextEnabled = false;
      nextLabel = l10n.next;
      onPrimary = null;
    }

    Widget primaryButton() {
      return Material(
        color: nextEnabled
            ? accent
            : (dark ? AppColors.inputDark : AppColors.inputLight),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPrimary,
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: Text(
              nextLabel,
              style: TextStyle(
                color: nextEnabled ? AppColors.onVivid : muted,
                fontSize: 16,
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
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(0, 52),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: notifier.prevStep,
            child: Text(l10n.back),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: primaryButton()),
      ],
    );
  }
}
