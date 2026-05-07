import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount, {String symbol = '₹'}) {
    final f = NumberFormat.currency(
      locale: 'en_IN',
      symbol: symbol,
      decimalDigits: 2,
    );
    return f.format(amount);
  }

  static String formatIndianInputDisplay(String raw, {bool allowEmpty = false}) {
    final cleaned = formatInput(raw);
    if (cleaned.isEmpty) return allowEmpty ? '' : '0';

    final dot = cleaned.indexOf('.');
    final wholePart = dot == -1 ? cleaned : cleaned.substring(0, dot);
    final fracPart = dot == -1 ? null : cleaned.substring(dot + 1);

    if (wholePart.isEmpty) {
      if (fracPart == null) return allowEmpty ? '' : '0';
      return fracPart.isEmpty ? '0.' : '0.$fracPart';
    }

    final groupedWhole = _groupIndianWholeDigits(wholePart);
    if (fracPart != null) return '$groupedWhole.$fracPart';
    if (dot != -1) return '$groupedWhole.';
    return groupedWhole;
  }

  static String _groupIndianWholeDigits(String digits) {
    if (digits.isEmpty) return '0';
    final n = int.tryParse(digits);
    if (n != null && digits.length <= 18) {
      return NumberFormat('#,##,##,###', 'en_IN').format(n);
    }
    return _groupIndianWholeFromString(digits);
  }

  static String _groupIndianWholeFromString(String s) {
    final d = s.replaceFirst(RegExp(r'^0+'), '');
    if (d.isEmpty) return '0';
    if (d.length <= 3) return d;
    final buf = <String>[];
    var pos = d.length;
    buf.add(d.substring(pos - 3));
    pos -= 3;
    while (pos > 0) {
      final len = pos >= 2 ? 2 : pos;
      buf.add(d.substring(pos - len, pos));
      pos -= len;
    }
    return buf.reversed.join(',');
  }

  static double parse(String formatted) {
    final stripped = formatted.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(stripped) ?? 0;
  }

  /// Keeps at most one decimal separator; strips non-numeric except one `.`.
  static String formatInput(String raw) {
    final buf = StringBuffer();
    var sawDot = false;
    for (var i = 0; i < raw.length; i++) {
      final ch = raw[i];
      if (ch == '.' || ch == ',') {
        if (!sawDot) {
          sawDot = true;
          buf.write('.');
        }
        continue;
      }
      if (ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57) buf.write(ch);
    }
    return buf.toString();
  }
}
