import 'dart:io';

import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/result.dart';

/// Typed exceptions thrown inside the data layer and mapped to [Failure].
sealed class AppException implements Exception {
  const AppException([this.message]);

  final String? message;
}

final class StorageException extends AppException {
  const StorageException([super.message]);
}

final class DataNotFoundException extends AppException {
  const DataNotFoundException([super.message]);
}

final class DuplicateMobileException extends AppException {
  const DuplicateMobileException([super.message]);
}

final class ActiveLoanException extends AppException {
  const ActiveLoanException([super.message]);
}

final class OutOfOrderPaymentException extends AppException {
  const OutOfOrderPaymentException([super.message]);
}

final class AlreadyPaidException extends AppException {
  const AlreadyPaidException([super.message]);
}

final class LoanNotPaidException extends AppException {
  const LoanNotPaidException([super.message]);
}

final class NetworkException extends AppException {
  const NetworkException([super.message]);
}

final class CryptoException extends AppException {
  const CryptoException([super.message]);
}

/// Maps any thrown object to a [Failure] so raw exceptions never reach the UI.
abstract final class ExceptionHandler {
  static Failure toFailure(Object error) {
    return switch (error) {
      final Failure failure => failure,
      StorageException(:final message) => DatabaseFailure(message),
      DataNotFoundException(:final message) => NotFoundFailure(message),
      DuplicateMobileException(:final message) =>
        DuplicateMobileFailure(message),
      ActiveLoanException(:final message) => ActiveLoanFailure(message),
      OutOfOrderPaymentException(:final message) =>
        OutOfOrderPaymentFailure(message),
      AlreadyPaidException(:final message) => AlreadyPaidFailure(message),
      LoanNotPaidException(:final message) => LoanNotPaidFailure(message),
      NetworkException(:final message) => NetworkFailure(message),
      CryptoException(:final message) =>
        WrongPasswordOrCorruptFailure(message),
      SocketException() => const NetworkFailure(),
      // Only the type name is kept: error text may contain user data.
      _ => UnknownFailure(error.runtimeType.toString()),
    };
  }

  /// Runs [action] and converts the outcome (or any throw) into a [Result].
  static Future<Result<T>> guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Object catch (error) {
      return Err(toFailure(error));
    }
  }
}
