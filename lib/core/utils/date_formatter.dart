import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDisplay(DateTime dt) => DateFormat('dd MMM y').format(dt);

  static String formatGroupHeader(
    DateTime dt, {
    DateTime? clock,
    required String todayLabel,
    required String yesterdayLabel,
  }) {
    final n = clock ?? DateTime.now();
    if (_sameDay(dt, n)) return todayLabel;
    if (_sameDay(dt, n.subtract(const Duration(days: 1)))) {
      return yesterdayLabel;
    }
    return formatDisplay(dt);
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String formatShort(DateTime dt) => DateFormat('dd MMM').format(dt);

  static DateTime startOfMonth(DateTime dt) =>
      DateTime(dt.year, dt.month, 1);

  static DateTime endOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999);
}
