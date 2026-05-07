import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';

import '../../model/chart_data_model.dart';
import '../painter/weekly_bar_painter.dart';

class WeeklyBarChartCard extends StatelessWidget {
  const WeeklyBarChartCard({super.key, required this.data});

  final List<WeeklyBarData> data;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final card = dark ? AppColors.cardDark : AppColors.cardLight;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.dashboardWeeklySpending,
            style: TextStyle(
              color: title,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 70,
            width: double.infinity,
            child: CustomPaint(
              painter: WeeklyBarPainter(data: data, isDark: dark),
            ),
          ),
        ],
      ),
    );
  }
}
