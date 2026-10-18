import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/domain/entities/customer.dart';

extension CustomerRowMapper on CustomerRow {
  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      mobile: mobile,
      address: address,
      notes: notes,
      smsConsent: smsConsent,
      photoPath: photoPath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension CustomerEntityMapper on Customer {
  /// All columns except `isDeleted`, which is only changed by soft delete.
  CustomersCompanion toCompanion() {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      mobile: Value(mobile),
      address: Value(address),
      notes: Value(notes),
      smsConsent: Value(smsConsent),
      photoPath: Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
