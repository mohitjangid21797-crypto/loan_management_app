import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils.addMonthsClamped', () {
    test('clamps to month end without drifting', () {
      final start = DateTime.utc(2025, 1, 31);
      expect(
        AppDateUtils.addMonthsClamped(start, 1),
        DateTime.utc(2025, 2, 28),
      );
      expect(
        AppDateUtils.addMonthsClamped(start, 2),
        DateTime.utc(2025, 3, 31),
      );
    });

    test('respects leap years', () {
      expect(
        AppDateUtils.addMonthsClamped(DateTime.utc(2024, 1, 31), 1),
        DateTime.utc(2024, 2, 29),
      );
    });

    test('rolls over the year', () {
      expect(
        AppDateUtils.addMonthsClamped(DateTime.utc(2025, 11, 15), 3),
        DateTime.utc(2026, 2, 15),
      );
    });
  });

  group('AppDateUtils.isOverdue', () {
    final today = DateTime.utc(2026, 10, 17);

    test('is overdue only when due before today', () {
      expect(
        AppDateUtils.isOverdue(DateTime.utc(2026, 10, 16), today: today),
        isTrue,
      );
      expect(
        AppDateUtils.isOverdue(DateTime.utc(2026, 10, 17), today: today),
        isFalse,
      );
      expect(
        AppDateUtils.isOverdue(DateTime.utc(2026, 10, 18), today: today),
        isFalse,
      );
    });
  });

  test('toIsoDate formats yyyy-MM-dd', () {
    expect(AppDateUtils.toIsoDate(DateTime.utc(2026, 3, 5)), '2026-03-05');
  });
}
