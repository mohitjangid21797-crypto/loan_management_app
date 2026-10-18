import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/domain/repositories/customer_repository.dart';

/// Streams customers whose name or mobile contains the query, ignoring case.
/// A blank query returns everyone.
class SearchCustomers {
  const SearchCustomers(this._repository);

  final CustomerRepository _repository;

  Stream<List<Customer>> call(String query) {
    return _repository.watchCustomers(query: query.trim());
  }
}
