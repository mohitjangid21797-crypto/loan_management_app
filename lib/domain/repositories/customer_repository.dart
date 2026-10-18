import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/domain/entities/customer.dart';

/// Stores customers. Implementations enforce the data rules below.
abstract interface class CustomerRepository {
  /// Non-deleted customers, newest first. A non-empty [query] keeps only
  /// customers whose name or mobile contains it, ignoring case.
  Stream<List<Customer>> watchCustomers({String query = ''});

  /// Emits the customer whenever it changes; null if missing or deleted.
  Stream<Customer?> watchCustomer(String id);

  /// Fails with a not-found failure for a missing or deleted customer.
  Future<Result<Customer>> getCustomer(String id);

  /// Fails with a duplicate-mobile failure if another non-deleted customer
  /// already has the same mobile.
  Future<Result<void>> addCustomer(Customer customer);

  /// Same duplicate rule as [addCustomer], ignoring the customer itself.
  Future<Result<void>> updateCustomer(Customer customer);

  /// Soft-deletes. Fails with an active-loan failure while the customer
  /// still has an active loan.
  Future<Result<void>> deleteCustomer(String id, {required DateTime at});
}
