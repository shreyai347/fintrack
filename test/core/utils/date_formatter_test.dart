import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatDisplay and formatShort', () {
    final d = DateTime(2026, 5, 7);
    expect(DateFormatter.formatDisplay(d), '07 May 2026');
    expect(DateFormatter.formatShort(d), '07 May');
  });

  test('formatGroupHeader relative days', () {
    final clock = DateTime(2026, 5, 7, 12);
    expect(
      DateFormatter.formatGroupHeader(
        DateTime(2026, 5, 7),
        clock: clock,
      ),
      AppStrings.today,
    );
    expect(
      DateFormatter.formatGroupHeader(
        DateTime(2026, 5, 6),
        clock: clock,
      ),
      AppStrings.yesterday,
    );
    expect(
      DateFormatter.formatGroupHeader(
        DateTime(2026, 1, 1),
        clock: clock,
      ),
      '01 Jan 2026',
    );
  });
}
