import 'package:flutter/foundation.dart';
import 'package:noteys/services/auth/user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState(
    this.isLoading, {
    this.loadingText = 'Please wait for a moment 😁',
  });
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized({
    required bool isLoading,
  }) : super(isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(Exception this.exception,
      {required bool isLoading})
      : super(isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final User user;

  const AuthStateLoggedIn(this.user, {required bool isLoading})
      : super(isLoading);
}

class AuthStateShouldVerify extends AuthState {
  const AuthStateShouldVerify({required bool isLoading}) : super(isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut(this.exception, bool isLoading, String? loadingText)
      : super(isLoading, loadingText: loadingText);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateNotRegistered extends AuthState {
  const AuthStateNotRegistered({required bool isLoading}) : super(isLoading);
}

class AuthStateRegistered extends AuthState {
  const AuthStateRegistered({required bool isLoading}) : super(isLoading);
}

class AuthStateForgotPassword extends AuthState {
  final bool hasSentEmail;
  final Exception? exception;
  const AuthStateForgotPassword({
    required bool isLoading,
    required this.hasSentEmail,
    required this.exception,
  }) : super(isLoading);
}
