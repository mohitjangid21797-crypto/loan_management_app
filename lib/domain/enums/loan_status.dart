/// Whether a loan still has installments to pay.
enum LoanStatus {
  active('active'),
  completed('completed');

  const LoanStatus(this.dbValue);

  /// The text stored in the database.
  final String dbValue;

  static LoanStatus fromDb(String value) {
    return LoanStatus.values.firstWhere(
      (status) => status.dbValue == value,
      orElse: () => throw ArgumentError.value(value, 'value', 'Unknown status'),
    );
  }
}
