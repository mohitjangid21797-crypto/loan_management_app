/// How interest is charged on a loan.
enum LoanType {
  /// Flat interest on the original principal, split evenly over the tenure.
  simple('simple'),

  /// Interest on the outstanding balance each month (reducing balance).
  compound('compound');

  const LoanType(this.dbValue);

  /// The text stored in the database.
  final String dbValue;

  static LoanType fromDb(String value) {
    return LoanType.values.firstWhere(
      (type) => type.dbValue == value,
      orElse: () => throw ArgumentError.value(value, 'value', 'Unknown type'),
    );
  }
}
