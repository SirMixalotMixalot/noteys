import 'package:flutter/foundation.dart';
import 'package:noteys/services/auth/user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(Exception this.exception);
}

class AuthStateLoggedIn extends AuthState {
  final User user;

  const AuthStateLoggedIn(this.user);
}

class AuthStateShouldVerify extends AuthState {
  const AuthStateShouldVerify();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut(this.exception, this.isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateNotRegistered extends AuthState {
  const AuthStateNotRegistered();
}

class AuthStateRegistered extends AuthState {
  const AuthStateRegistered();
}
