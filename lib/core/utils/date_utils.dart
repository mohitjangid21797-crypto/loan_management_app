import 'package:intl/intl.dart';

/// Date helpers. Business dates are stored as UTC midnight.
abstract final class AppDateUtils {
  /// The calendar date of [date] as UTC midnight.
  static DateTime utcMidnight(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  /// Today's local calendar date as UTC midnight.
  static DateTime today() => utcMidnight(DateTime.now());

  /// An instalment is overdue when its due date is before [today].
  static bool isOverdue(DateTime dueDate, {DateTime? today}) {
    return utcMidnight(dueDate).isBefore(utcMidnight(today ?? _now()));
  }

  /// Adds [months] to [start], keeping the same day of month but clamping to
  /// the month end (31 Jan -> 28/29 Feb -> 31 Mar). Always counts from
  /// [start], so clamping never drifts.
  static DateTime addMonthsClamped(DateTime start, int months) {
    final monthIndex = start.month - 1 + months;
    final year = start.year + monthIndex ~/ 12;
    final month = monthIndex % 12 + 1;
    final lastDay = DateTime.utc(year, month + 1, 0).day;
    final day = start.day > lastDay ? lastDay : start.day;
    return DateTime.utc(year, month, day);
  }

  /// `yyyy-MM-dd`, for storage and file names.
  static String toIsoDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Localized medium date, for example "17 Oct 2026".
  static String formatDisplay(DateTime date, String localeName) {
    return DateFormat.yMMMd(localeName).format(date);
  }

  static DateTime _now() => DateTime.now();
}
