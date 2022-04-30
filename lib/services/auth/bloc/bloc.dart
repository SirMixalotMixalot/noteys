import 'package:bloc/bloc.dart';
import 'package:noteys/services/auth/bloc/events.dart';
import 'package:noteys/services/auth/bloc/states.dart';
import 'package:noteys/services/auth/provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUnInitialized()) {
    on<AuthEventInitialized>(
      (_, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(null, false));
        } else if (!user.isEmailVerified) {
          //await provider.sendEmailVerification();
          emit(const AuthStateShouldVerify());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      },
    );
    on<AuthEventSendVerifyEmail>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateNotRegistered());
      },
    );
    on<AuthEventRegister>(
      (event, emit) async {
        try {
          final email = event.email;
          final password = event.password;

          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerification();
          emit(const AuthStateShouldVerify());
        } on Exception {
          emit(const AuthStateShouldVerify());
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(null, true));
        try {
          final user = await provider.login(
              email: event.email, password: event.password);
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                null,
                false,
              ),
            );
            emit(const AuthStateShouldVerify());
          } else {
            emit(
              const AuthStateLoggedOut(
                null,
                false,
              ),
            );
            emit(AuthStateLoggedIn(user));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e, false));
        }
      },
    );
    on<AuthEventToLogIn>(
      (event, emit) {
        emit(const AuthStateLoggedOut(null, false));
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logout();
          emit(const AuthStateLoggedOut(null, false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e, false));
        }
      },
    );
  }
}
