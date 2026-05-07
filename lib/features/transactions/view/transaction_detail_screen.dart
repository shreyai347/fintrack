import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:fintrack/core/widgets/category_icon.dart';
import 'package:fintrack/features/receipt/view/image_preview_screen.dart';

import '../model/category_model.dart';
import '../viewmodel/transaction_provider.dart';
import '../viewmodel/transaction_state.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final int transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(transactionNotifierProvider);
    final tx = ref.watch(transactionByIdProvider(transactionId));
    final catsAsync = ref.watch(categoriesProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final cardBg = dark ? AppColors.cardDark : AppColors.cardLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final titleCol =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final green = dark ? AppColors.income : AppColors.incomeLight;
    final red = dark ? AppColors.expense : AppColors.expenseLight;

    Widget body;
    if (listState is TransactionLoading || listState is TransactionInitial) {
      body = const Center(child: CircularProgressIndicator());
    } else if (listState is TransactionError) {
      body = Center(child: Text(listState.message));
    } else if (tx == null) {
      body = Center(child: Text(AppStrings.transactionNotFound));
    } else {
      body = catsAsync.when(
        data: (cats) {
          CategoryModel? cat;
          for (final c in cats) {
            if (c.id == tx.categoryId) {
              cat = c;
              break;
            }
          }
          if (cat == null) {
            return Center(child: Text(AppStrings.transactionNotFound));
          }
          final isExpense = tx.amount < 0;
          final amtColor = isExpense ? red : green;
          final typeLabel = isExpense
              ? AppStrings.transactionsAmountExpense
              : AppStrings.transactionsAmountIncome;
          final lineTitle = (tx.note == null || tx.note!.trim().isEmpty)
              ? AppStrings.transactionsListFallbackTitle
              : tx.note!.trim();

          Widget row(String label, Widget value) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 128,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: value),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                color: cardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: border, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lineTitle,
                        style: TextStyle(
                          color: titleCol,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      row(
                        AppStrings.transactionDetailType,
                        Text(
                          typeLabel,
                          style: TextStyle(
                            color: amtColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      row(
                        AppStrings.transactionDetailAmount,
                        Text(
                          CurrencyFormatter.format(tx.amount),
                          style: TextStyle(
                            color: amtColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      row(
                        AppStrings.transactionDetailCategory,
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: cat.color,
                              child: CategoryIcon(
                                category: cat,
                                size: 22,
                                iconColor: AppColors.onVivid,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              cat.name,
                              style: TextStyle(
                                color: titleCol,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      row(
                        AppStrings.transactionDetailDate,
                        Text(
                          DateFormatter.formatDisplay(tx.date),
                          style: TextStyle(
                            color: titleCol,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      row(
                        AppStrings.transactionDetailRecurring,
                        Text(
                          tx.isRecurring
                              ? AppStrings.transactionDetailYes
                              : AppStrings.transactionDetailNo,
                          style: TextStyle(
                            color: titleCol,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (tx.note != null && tx.note!.trim().isNotEmpty)
                        row(
                          AppStrings.transactionDetailNote,
                          Text(
                            tx.note!.trim(),
                            style: TextStyle(
                              color: titleCol,
                              fontSize: 15,
                              height: 1.35,
                            ),
                          ),
                        ),
                      if (tx.receiptPath != null &&
                          tx.receiptPath!.trim().isNotEmpty)
                        row(
                          AppStrings.transactionsAttachReceipt,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.transactionDetailReceiptAttached,
                                style: TextStyle(
                                  color: titleCol,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FilledButton.tonalIcon(
                                  onPressed: () {
                                    Navigator.of(context).push<void>(
                                      MaterialPageRoute<void>(
                                        builder: (_) => ImagePreviewScreen(
                                          imagePath: tx.receiptPath!.trim(),
                                          readOnly: true,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.photo_outlined),
                                  label: Text(AppStrings.viewReceipt),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(AppStrings.transactionDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: AppStrings.transactionsEditTitle,
            onPressed: () async {
              await Navigator.of(context).pushNamed(
                AppRoutes.editTransaction,
                arguments: transactionId,
              );
              // List + detail already update via transactionNotifierProvider.
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
