import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/domain/repositories/customer_repository.dart';
import 'package:uuid/uuid.dart';

/// Validates and creates a customer.
class AddCustomer {
  AddCustomer(
    this._repository, {
    String Function()? newId,
    DateTime Function()? now,
  }) : _newId = newId ?? (() => const Uuid().v4()),
       _now = now ?? DateTime.now;

  final CustomerRepository _repository;
  final String Function() _newId;
  final DateTime Function() _now;

  /// Returns the saved customer, or a [ValidationFailure],
  /// [DuplicateMobileFailure] or storage failure.
  Future<Result<Customer>> call({
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
    final now = _now();
    final customer = Customer(
      id: _newId(),
      name: name.trim(),
      mobile: mobile.trim(),
      address: address.trim(),
      notes: notes.trim(),
      smsConsent: smsConsent,
      photoPath: photoPath,
      createdAt: now,
      updatedAt: now,
    );
    final failure = (await _repository.addCustomer(customer)).failureOrNull;
    return failure == null ? Success(customer) : Err(failure);
  }
}
