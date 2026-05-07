import 'package:flutter/material.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';

class EmptyTransactionWidget extends StatelessWidget {
  const EmptyTransactionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final muted =
        dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: muted,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.transactionsEmptyTitle,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: primary),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.transactionsEmptySubtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: muted),
          ),
        ],
      ),
    );
  }
}
