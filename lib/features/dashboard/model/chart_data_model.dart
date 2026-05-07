import 'package:flutter/material.dart';

class DonutSegment {
  const DonutSegment({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.categoryId,
  });

  final String label;
  final double amount;
  final double percentage;
  final Color color;
  final int categoryId;
}

class WeeklyBarData {
  const WeeklyBarData({
    required this.weekLabel,
    required this.amount,
    required this.isCurrentWeek,
  });

  final String weekLabel;
  final double amount;
  final bool isCurrentWeek;
}
