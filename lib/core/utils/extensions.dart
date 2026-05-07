import 'package:flutter/material.dart';

import 'currency_formatter.dart';

extension DateTimeExtensions on DateTime {
  bool get isToday => isSameDay(DateTime.now());

  bool get isYesterday =>
      isSameDay(DateTime.now().subtract(const Duration(days: 1)));

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension DoubleExtensions on double {
  String toFormattedCurrency({String symbol = '₹'}) =>
      CurrencyFormatter.format(this, symbol: symbol);
}

extension StringExtensions on String {
  Color toColor() {
    var hex = trim();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 6) {
      final v = int.tryParse(hex, radix: 16);
      if (v == null) return const Color(0xFF000000);
      return Color(0xFF000000 | v);
    }
    if (hex.length == 8) {
      final v = int.tryParse(hex, radix: 16);
      if (v == null) return const Color(0xFF000000);
      return Color(v);
    }
    return const Color(0xFF000000);
  }
}
