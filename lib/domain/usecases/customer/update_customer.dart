import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/domain/repositories/customer_repository.dart';

/// Validates and saves changes to an existing customer.
class UpdateCustomer {
  UpdateCustomer(this._repository, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final CustomerRepository _repository;
  final DateTime Function() _now;

  /// Keeps the id and creation time of [existing]; everything else comes from
  /// the arguments. Returns the saved customer or a failure.
  Future<Result<Customer>> call(
    Customer existing, {
    required String name,
    required String mobile,
    String address = '',
    String notes = '',
    bool smsConsent = false,
    String? photoPath,
  }) async {
    final invalid = Validators.name(name) ?? Validators.mobile(mobile);
    if (invalid != null) {
      return Err(ValidationFailure(invalid));
    }
    final updated = Customer(
      id: existing.id,
      name: name.trim(),
      mobile: mobile.trim(),
      address: address.trim(),
      notes: notes.trim(),
      smsConsent: smsConsent,
      photoPath: photoPath,
      createdAt: existing.createdAt,
      updatedAt: _now(),
    );
    final failure = (await _repository.updateCustomer(updated)).failureOrNull;
    return failure == null ? Success(updated) : Err(failure);
  }
}
