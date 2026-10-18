import 'package:equatable/equatable.dart';

/// A borrower. Customers are soft-deleted, so history stays readable.
class Customer extends Equatable {
  const Customer({
    required this.id,
    required this.name,
    required this.mobile,
    required this.createdAt,
    required this.updatedAt,
    this.address = '',
    this.notes = '',
    this.smsConsent = false,
    this.photoPath,
  });

  final String id;
  final String name;

  /// 10-digit Indian mobile number; unique among non-deleted customers.
  final String mobile;
  final String address;
  final String notes;

  /// Whether the customer agreed to receive SMS. Gates the SMS button.
  final bool smsConsent;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    mobile,
    address,
    notes,
    smsConsent,
    photoPath,
    createdAt,
    updatedAt,
  ];
}
