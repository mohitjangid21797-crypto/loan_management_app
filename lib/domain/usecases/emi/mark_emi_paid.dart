import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/domain/repositories/emi_repository.dart';

/// Records the full payment of one installment.
class MarkEmiPaid {
  MarkEmiPaid(
    this._repository, {
    this.allowOutOfOrder = false,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final EmiRepository _repository;

  /// When false (the default), earlier installments must be paid first.
  final bool allowOutOfOrder;
  final DateTime Function() _now;

  /// [paidDate] is reduced to its calendar date. The loan is completed
  /// automatically when this was the last unpaid installment.
  Future<Result<void>> call(String emiId, DateTime paidDate) {
    return _repository.markPaid(
      emiId: emiId,
      paidDate: AppDateUtils.utcMidnight(paidDate),
      at: _now(),
      allowOutOfOrder: allowOutOfOrder,
    );
  }
}
