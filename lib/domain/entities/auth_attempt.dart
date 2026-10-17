import 'package:equatable/equatable.dart';

/// Result of checking an MPIN.
class AuthAttempt extends Equatable {
  const AuthAttempt({
    required this.success,
    this.failedAttempts = 0,
    this.remainingAttempts = 0,
    this.lockedUntil,
  });

  /// True when the MPIN matched.
  final bool success;

  /// Wrong attempts counted so far.
  final int failedAttempts;

  /// Wrong attempts left before the next lockout.
  final int remainingAttempts;

  /// Set while input is locked out.
  final DateTime? lockedUntil;

  @override
  List<Object?> get props => [
    success,
    failedAttempts,
    remainingAttempts,
    lockedUntil,
  ];
}
