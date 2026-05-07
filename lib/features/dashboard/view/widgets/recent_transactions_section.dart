import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';

import '../../../transactions/model/category_model.dart';
import '../../../transactions/model/transaction_model.dart';
import '../../../transactions/view/widgets/transaction_card.dart';

class RecentTransactionsSection extends ConsumerWidget {
  const RecentTransactionsSection({
    super.key,
    required this.transactions,
    required this.categories,
  });

  final List<TransactionModel> transactions;
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final cardBg = dark ? AppColors.cardDark : AppColors.cardLight;

    CategoryModel? cat(int id) {
      for (final c in categories) {
        if (c.id == id) return c;
      }
      return null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.recentTransactions,
              style: TextStyle(
                color: title,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.info_outline,
                size: 22,
                color: dark ? AppColors.accentDark : AppColors.accentLight,
              ),
              tooltip: l10n.transactionsHelpTitle,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.transactionsHelp);
              },
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.transactions);
              },
              child: Text(
                l10n.seeAll,
                style: TextStyle(
                  color: dark ? AppColors.accentDark : AppColors.accentLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (transactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.transactionsEmptyTitle,
                style: TextStyle(color: muted),
              ),
            ),
          )
        else
          ...transactions.map((tx) {
            final c = cat(tx.categoryId);
            if (c == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Material(
                color: Colors.transparent,
                child: Card(
                  elevation: 0,
                  color: cardBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: border, width: 0.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: TransactionCard(transaction: tx, category: c),
                ),
              ),
            );
          }),
      ],
    );
  }
}
