import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/widgets/category_icon.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/generated/database/app_database.dart';

import '../../model/category_model.dart';
import '../../model/transaction_model.dart';
import '../../repository/transaction_repository_impl.dart';
import '../../viewmodel/transaction_provider.dart';

String _transactionLineTitle(String? note) {
  if (note == null || note.trim().isEmpty) {
    return AppStrings.transactionsListFallbackTitle;
  }
  return note.trim();
}

class TransactionCard extends ConsumerWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
    required this.category,
  });

  final TransactionModel transaction;
  final CategoryModel category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final green = dark ? AppColors.income : AppColors.incomeLight;
    final red = dark ? AppColors.expense : AppColors.expenseLight;
    final amtColor = transaction.amount >= 0 ? green : red;

    return Dismissible(
      key: ValueKey<int>(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
            child: const Icon(Icons.delete, color: AppColors.onVivid),
      ),
      onDismissed: (_) async {
        final backup = transaction;
        await ref.read(transactionNotifierProvider.notifier).deleteTransaction(
              transaction.id,
            );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.transactionsDeleted),
            action: SnackBarAction(
              label: AppStrings.transactionsUndo,
              onPressed: () {
                ref.read(transactionRepositoryProvider).add(
                      TransactionsCompanion.insert(
                        amount: backup.amount,
                        categoryId: backup.categoryId,
                        note: Value(backup.note),
                        date: backup.date,
                        receiptPath: Value(backup.receiptPath),
                        isRecurring: Value(backup.isRecurring),
                        recurringRuleId: Value(backup.recurringRuleId),
                      ),
                    );
              },
            ),
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.editTransaction,
              arguments: transaction.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: category.color,
                  child: CategoryIcon(
                    category: category,
                    size: 28,
                    iconColor: AppColors.onVivid,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _transactionLineTitle(transaction.note),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        category.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: dark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  CurrencyFormatter.format(transaction.amount),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: amtColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
