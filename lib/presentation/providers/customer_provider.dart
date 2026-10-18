import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/data/repositories/customer_repository_impl.dart';
import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/domain/repositories/customer_repository.dart';
import 'package:loan_management_app/domain/usecases/customer/add_customer.dart';
import 'package:loan_management_app/domain/usecases/customer/delete_customer.dart';
import 'package:loan_management_app/domain/usecases/customer/get_customers.dart';
import 'package:loan_management_app/domain/usecases/customer/search_customers.dart';
import 'package:loan_management_app/domain/usecases/customer/update_customer.dart';
import 'package:loan_management_app/presentation/providers/database_provider.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepositoryImpl(ref.watch(databaseProvider).customerDao);
});

final addCustomerProvider = Provider<AddCustomer>((ref) {
  return AddCustomer(ref.watch(customerRepositoryProvider));
});

final updateCustomerProvider = Provider<UpdateCustomer>((ref) {
  return UpdateCustomer(ref.watch(customerRepositoryProvider));
});

final deleteCustomerProvider = Provider<DeleteCustomer>((ref) {
  return DeleteCustomer(ref.watch(customerRepositoryProvider));
});

final getCustomersProvider = Provider<GetCustomers>((ref) {
  return GetCustomers(ref.watch(customerRepositoryProvider));
});

final searchCustomersProvider = Provider<SearchCustomers>((ref) {
  return SearchCustomers(ref.watch(customerRepositoryProvider));
});

/// The text in the customer search box (already debounced by the UI).
class CustomerQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query.trim();
}

final customerQueryProvider = NotifierProvider<CustomerQueryNotifier, String>(
  CustomerQueryNotifier.new,
);

/// Customers for the list screen: everyone, or the search matches.
final customersProvider = StreamProvider.autoDispose<List<Customer>>((ref) {
  final query = ref.watch(customerQueryProvider);
  if (query.isEmpty) {
    return ref.watch(getCustomersProvider)();
  }
  return ref.watch(searchCustomersProvider)(query);
});

/// One customer by id; emits null once the customer is deleted.
final customerDetailProvider = StreamProvider.autoDispose
    .family<Customer?, String>((ref, id) {
      return ref.watch(customerRepositoryProvider).watchCustomer(id);
    });
