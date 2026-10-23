import 'package:equatable/equatable.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';

/// An overdue installment together with who owes it.
class OverdueEmi extends Equatable {
  const OverdueEmi({
    required this.emi,
    required this.customerId,
    required this.customerName,
  });

  final EmiSchedule emi;
  final String customerId;
  final String customerName;

  @override
  List<Object?> get props => [emi, customerId, customerName];
}
