import 'package:uuid/uuid.dart';

enum EMIStatus { pending, paid, overdue }

class EMI {
  final String id;
  final String loanId;
  final int installmentNumber;
  final double amount;
  final DateTime dueDate;
  EMIStatus status;
  DateTime? paidDate;
  String? paymentMethod;
  String? transactionId;

  EMI({
    String? id,
    required this.loanId,
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
    this.status = EMIStatus.pending,
    this.paidDate,
    this.paymentMethod,
    this.transactionId,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'loanId': loanId,
        'installmentNumber': installmentNumber,
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
        'status': status.name,
        'paidDate': paidDate?.toIso8601String(),
        'paymentMethod': paymentMethod,
        'transactionId': transactionId,
      };

  factory EMI.fromJson(Map<String, dynamic> json) => EMI(
        id: json['id'],
        loanId: json['loanId'],
        installmentNumber: json['installmentNumber'],
        amount: json['amount'].toDouble(),
        dueDate: DateTime.parse(json['dueDate']),
        status: EMIStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => EMIStatus.pending,
        ),
        paidDate: json['paidDate'] != null
            ? DateTime.parse(json['paidDate'])
            : null,
        paymentMethod: json['paymentMethod'],
        transactionId: json['transactionId'],
      );

  EMI copyWith({
    EMIStatus? status,
    DateTime? paidDate,
    String? paymentMethod,
    String? transactionId,
  }) => EMI(
        id: id,
        loanId: loanId,
        installmentNumber: installmentNumber,
        amount: amount,
        dueDate: dueDate,
        status: status ?? this.status,
        paidDate: paidDate ?? this.paidDate,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        transactionId: transactionId ?? this.transactionId,
      );

  bool get isOverdue => status == EMIStatus.pending && dueDate.isBefore(DateTime.now());
}