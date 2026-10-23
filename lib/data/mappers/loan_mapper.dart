import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';

extension LoanRowMapper on LoanRow {
  Loan toEntity() {
    return Loan(
      id: id,
      customerId: customerId,
      type: LoanType.fromDb(type),
      principalPaise: principalPaise,
      annualRatePercent: annualRatePercent,
      tenureMonths: tenureMonths,
      startDate: startDate,
      emiPaise: emiPaise,
      totalInterestPaise: totalInterestPaise,
      status: LoanStatus.fromDb(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension LoanEntityMapper on Loan {
  LoansCompanion toCompanion() {
    return LoansCompanion(
      id: Value(id),
      customerId: Value(customerId),
      type: Value(type.dbValue),
      principalPaise: Value(principalPaise),
      annualRatePercent: Value(annualRatePercent),
      tenureMonths: Value(tenureMonths),
      startDate: Value(startDate),
      emiPaise: Value(emiPaise),
      totalInterestPaise: Value(totalInterestPaise),
      status: Value(status.dbValue),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
