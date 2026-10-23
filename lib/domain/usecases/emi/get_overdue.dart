import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/domain/entities/overdue_emi.dart';
import 'package:loan_management_app/domain/repositories/emi_repository.dart';

/// Streams pending installments due before today, oldest first.
class GetOverdue {
  GetOverdue(this._repository, {DateTime Function()? today})
    : _today = today ?? AppDateUtils.today;

  final EmiRepository _repository;
  final DateTime Function() _today;

  Stream<List<OverdueEmi>> call() {
    return _repository.watchOverdue(today: _today());
  }
}
