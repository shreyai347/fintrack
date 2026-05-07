import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/generated/database/app_database.dart';

import 'package:fintrack/features/transactions/model/recurring_transaction_model.dart';
import 'package:fintrack/features/transactions/repository/transaction_repository_impl.dart';
import 'package:fintrack/features/transactions/viewmodel/transaction_provider.dart';

Future<void> persistNewTransaction(
  BuildContext context,
  WidgetRef ref,
  TextEditingController noteController,
) async {
  final w = ref.read(addTransactionWizardProvider);
  final double parsed = w.parsedAmount;
  if (parsed <= 0 || w.selectedCategoryId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.validationAmountRequired)),
    );
    return;
  }
  final double amountForDb = w.isExpense
      ? -parsed.toDouble().abs()
      : parsed.toDouble().abs();
  final FrequencyType? recurring = switch (w.recurringFrequency) {
    'daily' => FrequencyType.daily,
    'weekly' => FrequencyType.weekly,
    'monthly' => FrequencyType.monthly,
    _ => null,
  };
  final repo = ref.read(transactionRepositoryProvider);
  try {
    int? ruleId = w.baselineRecurringRuleId;
    if (recurring != null) {
      ruleId ??= await repo.addRecurringRule(
        RecurringRulesCompanion.insert(
          frequency: recurring.name,
          nextDueDate: w.selectedDate,
          isActive: const Value(true),
        ),
      );
    } else {
      ruleId = null;
    }

    final noteTrimmed = noteController.text.trim().isEmpty
        ? null
        : noteController.text.trim();

    if (w.editingId != null) {
      await ref.read(transactionNotifierProvider.notifier).updateTransaction(
            TransactionsCompanion(
              id: Value(w.editingId!),
              amount: Value(amountForDb),
              categoryId: Value(w.selectedCategoryId!),
              note: Value(noteTrimmed),
              date: Value(w.selectedDate),
              receiptPath: Value(w.receiptPath),
              isRecurring: Value(recurring != null),
              recurringRuleId: Value<int?>(ruleId),
            ),
          );
    } else {
      final companion = TransactionsCompanion.insert(
        amount: amountForDb,
        categoryId: w.selectedCategoryId!,
        note: Value(noteTrimmed),
        date: w.selectedDate,
        receiptPath: Value(w.receiptPath),
        isRecurring: Value(recurring != null),
        recurringRuleId: Value<int?>(ruleId),
      );
      await ref.read(transactionNotifierProvider.notifier).addTransaction(
            companion,
          );
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.transactionsSaved)),
    );
    ref.read(addTransactionWizardProvider.notifier).reset();
    Navigator.of(context).pop();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }
}
