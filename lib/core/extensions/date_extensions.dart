import 'package:loan_management_app/core/utils/date_utils.dart';

extension DateTimeX on DateTime {
  /// The calendar date of this value as UTC midnight.
  DateTime get utcMidnight => AppDateUtils.utcMidnight(this);

  /// `yyyy-MM-dd`.
  String get isoDate => AppDateUtils.toIsoDate(this);
}
