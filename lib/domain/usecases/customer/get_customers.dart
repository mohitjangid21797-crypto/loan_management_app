import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/domain/repositories/customer_repository.dart';

/// Streams all non-deleted customers, newest first.
class GetCustomers {
  const GetCustomers(this._repository);

  final CustomerRepository _repository;

  Stream<List<Customer>> call() => _repository.watchCustomers();
}
