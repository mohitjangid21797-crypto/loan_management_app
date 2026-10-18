import 'package:loan_management_app/core/error/exception_handler.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/data/local/daos/customer_dao.dart';
import 'package:loan_management_app/data/mappers/customer_mapper.dart';
import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._dao);

  final CustomerDao _dao;

  @override
  Stream<List<Customer>> watchCustomers({String query = ''}) {
    return _dao
        .watchAll(query: query)
        .map((rows) => [for (final row in rows) row.toEntity()]);
  }

  @override
  Stream<Customer?> watchCustomer(String id) {
    return _dao.watchById(id).map((row) => row?.toEntity());
  }

  @override
  Future<Result<Customer>> getCustomer(String id) {
    return ExceptionHandler.guard(() async {
      final row = await _dao.getById(id);
      if (row == null) {
        throw const DataNotFoundException('customer');
      }
      return row.toEntity();
    });
  }

  @override
  Future<Result<void>> addCustomer(Customer customer) {
    return ExceptionHandler.guard(() {
      return _dao.transaction(() async {
        await _requireFreeMobile(customer.mobile, ownId: customer.id);
        await _dao.insertRow(customer.toCompanion());
      });
    });
  }

  @override
  Future<Result<void>> updateCustomer(Customer customer) {
    return ExceptionHandler.guard(() {
      return _dao.transaction(() async {
        await _requireFreeMobile(customer.mobile, ownId: customer.id);
        final changed = await _dao.updateRow(
          customer.id,
          customer.toCompanion(),
        );
        if (changed == 0) {
          throw const DataNotFoundException('customer');
        }
      });
    });
  }

  @override
  Future<Result<void>> deleteCustomer(String id, {required DateTime at}) {
    return ExceptionHandler.guard(() {
      return _dao.transaction(() async {
        if (await _dao.countActiveLoans(id) > 0) {
          throw const ActiveLoanException('customer has an active loan');
        }
        final changed = await _dao.softDelete(id, at);
        if (changed == 0) {
          throw const DataNotFoundException('customer');
        }
      });
    });
  }

  Future<void> _requireFreeMobile(String mobile, {required String ownId}) async {
    final existing = await _dao.findByMobile(mobile);
    if (existing != null && existing.id != ownId) {
      throw const DuplicateMobileException('mobile in use');
    }
  }
}
