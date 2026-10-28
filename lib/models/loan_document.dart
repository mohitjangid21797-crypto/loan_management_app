import 'package:uuid/uuid.dart';

class LoanDocument {
  final String id;
  final String loanId;
  final String customerId;
  final String fileName;
  String filePath;
  final DateTime generatedAt;
  final double totalAmount;
  final int totalEMIs;
  final int paidEMIs;

  LoanDocument({
    String? id,
    required this.loanId,
    required this.customerId,
    required this.fileName,
    required this.filePath,
    required this.generatedAt,
    required this.totalAmount,
    required this.totalEMIs,
    required this.paidEMIs,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'loanId': loanId,
        'customerId': customerId,
        'fileName': fileName,
        'filePath': filePath,
        'generatedAt': generatedAt.toIso8601String(),
        'totalAmount': totalAmount,
        'totalEMIs': totalEMIs,
        'paidEMIs': paidEMIs,
      };

  factory LoanDocument.fromJson(Map<String, dynamic> json) => LoanDocument(
        id: json['id'],
        loanId: json['loanId'],
        customerId: json['customerId'],
        fileName: json['fileName'],
        filePath: json['filePath'],
        generatedAt: DateTime.parse(json['generatedAt']),
        totalAmount: json['totalAmount'].toDouble(),
        totalEMIs: json['totalEMIs'],
        paidEMIs: json['paidEMIs'],
      );

  LoanDocument copyWith({
    String? filePath,
  }) => LoanDocument(
        id: id,
        loanId: loanId,
        customerId: customerId,
        fileName: fileName,
        filePath: filePath ?? this.filePath,
        generatedAt: generatedAt,
        totalAmount: totalAmount,
        totalEMIs: totalEMIs,
        paidEMIs: paidEMIs,
      );
}