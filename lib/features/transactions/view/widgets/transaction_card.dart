import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/core/widgets/category_icon.dart';
import 'package:fintrack/core/utils/category_localizations.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/widgets/fintrack_confirm_dialog.dart';
import 'package:fintrack/generated/database/app_database.dart';

import '../../model/category_model.dart';
import '../../model/transaction_model.dart';
import '../../viewmodel/transaction_provider.dart';

String _transactionLineTitle(BuildContext context, String? note) {
  final l10n = AppLocalizations.of(context)!;
  if (note == null || note.trim().isEmpty) {
    return l10n.transactionsListFallbackTitle;
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
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final green = dark ? AppColors.income : AppColors.incomeLight;
    final red = dark ? AppColors.expense : AppColors.expenseLight;
    final amtColor = transaction.amount >= 0 ? green : red;

    return Dismissible(
      key: ValueKey<int>(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showFintrackConfirmDialog(
        context: context,
        title: l10n.deleteConfirm,
        message: l10n.deleteConfirmSub,
        cancelLabel: l10n.cancel,
        confirmLabel: l10n.delete,
        destructiveConfirm: true,
      ),
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
            content: Text(l10n.transactionDeleted),
            action: SnackBarAction(
              label: l10n.undoDelete,
              onPressed: () async {
                await ref.read(transactionNotifierProvider.notifier).addTransaction(
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
              AppRoutes.transactionDetail,
              arguments: transaction.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: category.color,
                  child: CategoryIcon(
                    category: category,
                    size: 32,
                    iconColor: AppColors.onVivid,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _transactionLineTitle(context, transaction.note),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: dark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizedCategoryName(l10n, category.name),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 15,
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: amtColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
