import 'package:uuid/uuid.dart';

enum InterestType { simple, compound }

class Loan {
  final String id;
  final String customerId;
  final double principalAmount;
  final double interestRate;
  final int tenureMonths;
  final InterestType interestType;
  final DateTime startDate;
  final DateTime createdAt;
  final String status;

  Loan({
    String? id,
    required this.customerId,
    required this.principalAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.interestType,
    DateTime? startDate,
    DateTime? createdAt,
    this.status = 'active',
  }) : id = id ?? const Uuid().v4(),
       startDate = startDate ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  double get totalInterest {
    if (interestType == InterestType.simple) {
      return (principalAmount * interestRate * tenureMonths) / (100 * 12);
    } else {
      double monthlyRate = interestRate / 100 / 12;
      return principalAmount * (pow(1 + monthlyRate, tenureMonths) - 1);
    }
  }

  double get totalAmount => principalAmount + totalInterest;

  double get monthlyEMI {
    if (interestType == InterestType.simple) {
      return totalAmount / tenureMonths;
    } else {
      double monthlyRate = interestRate / 100 / 12;
      return (principalAmount * monthlyRate * pow(1 + monthlyRate, tenureMonths)) /
          (pow(1 + monthlyRate, tenureMonths) - 1);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'principalAmount': principalAmount,
        'interestRate': interestRate,
        'tenureMonths': tenureMonths,
        'interestType': interestType.name,
        'startDate': startDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'status': status,
      };

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json['id'],
        customerId: json['customerId'],
        principalAmount: json['principalAmount'].toDouble(),
        interestRate: json['interestRate'].toDouble(),
        tenureMonths: json['tenureMonths'],
        interestType: InterestType.values.firstWhere(
          (e) => e.name == json['interestType'],
          orElse: () => InterestType.simple,
        ),
        startDate: DateTime.parse(json['startDate']),
        createdAt: DateTime.parse(json['createdAt']),
        status: json['status'] ?? 'active',
      );

  Loan copyWith({
    String? customerId,
    double? principalAmount,
    double? interestRate,
    int? tenureMonths,
    InterestType? interestType,
    DateTime? startDate,
    String? status,
  }) => Loan(
        id: id,
        customerId: customerId ?? this.customerId,
        principalAmount: principalAmount ?? this.principalAmount,
        interestRate: interestRate ?? this.interestRate,
        tenureMonths: tenureMonths ?? this.tenureMonths,
        interestType: interestType ?? this.interestType,
        startDate: startDate ?? this.startDate,
        createdAt: createdAt,
        status: status ?? this.status,
      );
}

double pow(double base, int exponent) {
  double result = 1;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}