import 'package:equatable/equatable.dart';
import 'package:loan_management_app/core/utils/validators.dart';

/// Typed failure surfaced to the UI. [debugMessage] must never contain PII.
sealed class Failure extends Equatable {
  const Failure([this.debugMessage]);

  final String? debugMessage;

  @override
  List<Object?> get props => [runtimeType, debugMessage];
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.debugMessage]);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure([super.debugMessage]);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.debugMessage]);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.debugMessage]);
}

final class DuplicateMobileFailure extends Failure {
  const DuplicateMobileFailure([super.debugMessage]);
}

final class ActiveLoanFailure extends Failure {
  const ActiveLoanFailure([super.debugMessage]);
}

/// An installment was paid while an earlier one is still unpaid.
final class OutOfOrderPaymentFailure extends Failure {
  const OutOfOrderPaymentFailure([super.debugMessage]);
}

final class AlreadyPaidFailure extends Failure {
  const AlreadyPaidFailure([super.debugMessage]);
}

/// A loan cannot be closed while installments are unpaid.
final class LoanNotPaidFailure extends Failure {
  const LoanNotPaidFailure([super.debugMessage]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(this.error);

  final ValidationError error;

  @override
  List<Object?> get props => [runtimeType, error];
}

/// Backup decryption failed: wrong password or damaged file.
final class WrongPasswordOrCorruptFailure extends Failure {
  const WrongPasswordOrCorruptFailure([super.debugMessage]);
}
