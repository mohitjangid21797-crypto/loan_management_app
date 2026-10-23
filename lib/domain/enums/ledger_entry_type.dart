/// Kind of ledger entry.
enum LedgerEntryType {
  /// A loan was given out; the customer now owes the total payable.
  disbursement('disbursement'),

  /// An installment was received.
  emiPayment('emi_payment'),

  /// A manual correction.
  adjustment('adjustment');

  const LedgerEntryType(this.dbValue);

  /// The text stored in the database.
  final String dbValue;

  static LedgerEntryType fromDb(String value) {
    return LedgerEntryType.values.firstWhere(
      (type) => type.dbValue == value,
      orElse: () => throw ArgumentError.value(value, 'value', 'Unknown type'),
    );
  }
}
