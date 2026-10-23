/// State of one installment.
///
/// Only [pending] and [paid] are stored. [overdue] is worked out from the due
/// date when it is needed, so there is a single overdue rule everywhere.
enum EmiStatus {
  pending('pending'),
  paid('paid'),
  overdue('overdue');

  const EmiStatus(this.dbValue);

  /// The text stored in the database.
  final String dbValue;

  static EmiStatus fromDb(String value) {
    return EmiStatus.values.firstWhere(
      (status) => status.dbValue == value,
      orElse: () => throw ArgumentError.value(value, 'value', 'Unknown status'),
    );
  }
}
