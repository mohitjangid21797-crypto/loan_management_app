import 'package:loan_management_app/core/error/failures.dart';

/// Outcome of an operation: either a [Success] value or an [Err] failure.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    Err<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    Err<T>(:final failure) => failure,
  };

  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final value) => success(value),
      Err<T>(failure: final f) => failure(f),
    };
  }
}

/// Successful result carrying [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// Failed result carrying a typed [failure].
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
