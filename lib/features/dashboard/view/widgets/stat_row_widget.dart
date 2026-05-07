import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';

class StatRowWidget extends StatelessWidget {
  const StatRowWidget({
    super.key,
    required this.dailyAvg,
    required this.txCount,
  });

  final double dailyAvg;
  final int txCount;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? AppColors.cardDark : AppColors.cardLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;

    Widget cell(String label, String value) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: muted, fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: title,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        cell(AppStrings.dashboardStatDailyAvg, CurrencyFormatter.format(dailyAvg)),
        const SizedBox(width: 12),
        cell(AppStrings.dashboardStatTransactions, '$txCount'),
      ],
    );
  }
}
