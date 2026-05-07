import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('format and parse currency', () {
    expect(CurrencyFormatter.format(1000.0), '₹1,000.00');
    expect(CurrencyFormatter.format(0.0), '₹0.00');
    expect(CurrencyFormatter.format(85000.0), '₹85,000.00');
    expect(CurrencyFormatter.parse('₹1,000.00'), 1000.0);
    expect(CurrencyFormatter.parse('₹0.00'), 0.0);
  });
}
