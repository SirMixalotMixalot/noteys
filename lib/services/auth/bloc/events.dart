import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialized extends AuthEvent {
  const AuthEventInitialized();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn(this.email, this.password);
}

class AuthEventToLogIn extends AuthEvent {
  const AuthEventToLogIn();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventVerify extends AuthEvent {
  final String email;
  const AuthEventVerify(this.email);
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister({required this.email, required this.password});
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventSendVerifyEmail extends AuthEvent {
  const AuthEventSendVerifyEmail();
}
