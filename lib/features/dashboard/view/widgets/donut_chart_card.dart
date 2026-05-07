import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';

import '../../model/chart_data_model.dart';
import '../painter/donut_chart_painter.dart';

class DonutChartCard extends StatelessWidget {
  const DonutChartCard({super.key, required this.segments});

  final List<DonutSegment> segments;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final track = dark ? AppColors.inputDark : AppColors.inputLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bold = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final card = dark ? AppColors.cardDark : AppColors.cardLight;

    final center =
        segments.isEmpty ? '—' : segments.first.label;

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
          SizedBox(
            height: 130,
            width: 130,
            child: CustomPaint(
              painter: DonutChartPainter(
                segments: segments,
                centerLabel: center,
                trackColor: track,
                mutedColor: muted,
                boldColor: bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...segments.map((s) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: s.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(s.label, style: TextStyle(color: bold, fontSize: 13))),
                  Text(
                    '${s.percentage.toStringAsFixed(0)}%',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    CurrencyFormatter.format(s.amount),
                    style: TextStyle(color: bold, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
