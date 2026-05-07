import 'package:flutter/material.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';

class TransactionsInfoScreen extends StatelessWidget {
  const TransactionsInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final cardBg = dark ? AppColors.cardDark : AppColors.cardLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final titleCol =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final bodyCol = dark ? AppColors.textMutedDark : AppColors.textMutedLight;

    Widget section(String heading, String body) {
      return Card(
        elevation: 0,
        color: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: border, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading,
                style: TextStyle(
                  color: titleCol,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: TextStyle(
                  color: bodyCol,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(l10n.transactionsHelpTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          section(
            l10n.transactionsHelpSpendingTitle,
            l10n.transactionsHelpSpendingBody,
          ),
          const SizedBox(height: 12),
          section(
            l10n.transactionsHelpIncomeTitle,
            l10n.transactionsHelpIncomeBody,
          ),
          const SizedBox(height: 12),
          section(
            l10n.transactionsHelpRecurringTitle,
            l10n.transactionsHelpRecurringBody,
          ),
        ],
      ),
    );
  }
}
