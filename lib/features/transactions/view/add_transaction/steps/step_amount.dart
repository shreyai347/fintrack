import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';

import '../../../viewmodel/transaction_provider.dart';
import '../add_transaction_utils.dart';
import '../step_scroll.dart';

class AddTransactionStepAmount extends ConsumerWidget {
  const AddTransactionStepAmount({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = ref.watch(addTransactionWizardProvider);
    final notifier = ref.read(addTransactionWizardProvider.notifier);
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;
    final input = dark ? AppColors.inputDark : AppColors.inputLight;
    final border =
        dark ? AppColors.borderDark : AppColors.borderLight;
    final muted =
        dark ? AppColors.textMutedDark : AppColors.textMutedLight;

    Color expSelFg() => dark ? AppColors.expense : AppColors.expenseLight;
    Color incSelFg() => dark ? AppColors.income : AppColors.incomeLight;

    Widget typeChip({
      required String label,
      required bool selected,
      required bool expense,
      required VoidCallback onTap,
    }) {
      final selC = expense ? expSelFg() : incSelFg();
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
            decoration: BoxDecoration(
              color: selected
                  ? selC.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: selected ? selC : border,
                width: 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? selC : muted,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    Widget numKey(String ch, VoidCallback onTap, {Color? fg}) {
      return Material(
        color: input,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 0.5),
            ),
            child: Text(
              ch,
              style: TextStyle(
                color: fg ?? primary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return AddTransactionStepScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              typeChip(
                label: AppStrings.transactionsAmountExpense,
                selected: w.isExpense,
                expense: true,
                onTap: () => notifier.setExpense(true),
              ),
              const SizedBox(width: 14),
              typeChip(
                label: AppStrings.transactionsAmountIncome,
                selected: !w.isExpense,
                expense: false,
                onTap: () => notifier.setExpense(false),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('₹', style: TextStyle(fontSize: 24, color: hint)),
              const SizedBox(width: 8),
              Text(
                formatAmountDisplay(w.amountString),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'tap to edit',
              style: TextStyle(fontSize: 13, color: accent),
            ),
          ),
          const SizedBox(height: 18),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: numKey('1', () => notifier.appendDigit('1'))),
                  const SizedBox(width: 8),
                  Expanded(child: numKey('2', () => notifier.appendDigit('2'))),
                  const SizedBox(width: 8),
                  Expanded(child: numKey('3', () => notifier.appendDigit('3'))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: numKey('4', () => notifier.appendDigit('4'))),
                  const SizedBox(width: 8),
                  Expanded(child: numKey('5', () => notifier.appendDigit('5'))),
                  const SizedBox(width: 8),
                  Expanded(child: numKey('6', () => notifier.appendDigit('6'))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: numKey('7', () => notifier.appendDigit('7'))),
                  const SizedBox(width: 8),
                  Expanded(child: numKey('8', () => notifier.appendDigit('8'))),
                  const SizedBox(width: 8),
                  Expanded(child: numKey('9', () => notifier.appendDigit('9'))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: numKey('.', notifier.appendDot)),
                  const SizedBox(width: 8),
                  Expanded(child: numKey('0', () => notifier.appendDigit('0'))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: numKey('⌫', notifier.backspace, fg: accent),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
