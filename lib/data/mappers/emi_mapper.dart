import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/domain/enums/emi_status.dart';

extension EmiRowMapper on EmiRow {
  EmiSchedule toEntity() {
    return EmiSchedule(
      id: id,
      loanId: loanId,
      installmentNo: installmentNo,
      dueDate: dueDate,
      principalPartPaise: principalPartPaise,
      interestPartPaise: interestPartPaise,
      emiPaise: emiPaise,
      paidPaise: paidPaise,
      paidDate: paidDate,
      status: EmiStatus.fromDb(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension EmiEntityMapper on EmiSchedule {
  EmisCompanion toCompanion() {
    return EmisCompanion(
      id: Value(id),
      loanId: Value(loanId),
      installmentNo: Value(installmentNo),
      dueDate: Value(dueDate),
      principalPartPaise: Value(principalPartPaise),
      interestPartPaise: Value(interestPartPaise),
      emiPaise: Value(emiPaise),
      paidPaise: Value(paidPaise),
      paidDate: Value(paidDate),
      status: Value(status.dbValue),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
