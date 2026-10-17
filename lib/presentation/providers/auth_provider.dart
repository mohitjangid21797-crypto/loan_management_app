import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the user is in the lock flow.
enum AuthStatus { unknown, needsSetup, locked, unlocked }

/// Phase 0 stub. Phase 1 replaces this with real MPIN state.
class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => AuthStatus.unknown;

  void setStatus(AuthStatus status) => state = status;
}

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);
