import 'package:fintrack/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('validateAmount', () {
    expect(Validators.validateAmount(null), isNotNull);
    expect(Validators.validateAmount(''), isNotNull);
    expect(Validators.validateAmount('0'), isNotNull);
    expect(Validators.validateAmount('-100'), isNotNull);
    expect(Validators.validateAmount('500'), isNull);
    expect(Validators.validateAmount('abc'), isNotNull);
  });

  test('validateNote', () {
    expect(Validators.validateNote(null), isNull);
    expect(Validators.validateNote('a' * 201), isNotNull);
    expect(Validators.validateNote('normal note'), isNull);
  });
}
