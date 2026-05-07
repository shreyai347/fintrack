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
