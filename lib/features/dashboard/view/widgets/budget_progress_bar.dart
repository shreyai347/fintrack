import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar(
    this.percent, {
    super.key,
    this.height = 4,
  });

  final double percent;
  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final widthFrac = percent.clamp(0.0, 1.0);
    final p = percent.clamp(0.0, 1.0);
    Color fill;
    if (p < 0.60) {
      fill = dark ? AppColors.income : AppColors.incomeLight;
    } else if (p <= 0.85) {
      fill = dark ? AppColors.accentDark : AppColors.accentLight;
    } else {
      fill = dark ? AppColors.expense : AppColors.expenseLight;
    }
    if (percent > 1.0) {
      fill = dark ? AppColors.expense : AppColors.expenseLight;
    }
    final track = dark ? AppColors.inputDark : AppColors.inputLight;

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth * widthFrac;
        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Stack(
            children: [
              Container(height: height, color: track),
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                height: height,
                width: w,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
