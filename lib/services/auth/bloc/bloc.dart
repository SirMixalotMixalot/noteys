import 'package:bloc/bloc.dart';
import 'package:noteys/services/auth/bloc/events.dart';
import 'package:noteys/services/auth/bloc/states.dart';
import 'package:noteys/services/auth/provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUnInitialized(isLoading: true)) {
    on<AuthEventInitialized>(
      (_, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(
            null,
            false,
            "Logging in",
          ));
        } else if (!user.isEmailVerified) {
          //await provider.sendEmailVerification();
          emit(const AuthStateShouldVerify(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(
            user,
            isLoading: false,
          ));
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
        emit(const AuthStateNotRegistered(
          isLoading: false,
        ));
      },
    );
    on<AuthEventRegister>(
      (event, emit) async {
        try {
          final email = event.email;
          final password = event.password;

          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerification();
          emit(const AuthStateShouldVerify(
            isLoading: false,
          ));
        } on Exception {
          emit(const AuthStateShouldVerify(
            isLoading: false,
          ));
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(null, true, null));
        try {
          final user = await provider.login(
              email: event.email, password: event.password);
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                null,
                false,
                null,
              ),
            );
            emit(const AuthStateShouldVerify(
              isLoading: false,
            ));
          } else {
            emit(
              const AuthStateLoggedOut(
                null,
                false,
                null,
              ),
            );
            emit(AuthStateLoggedIn(
              user,
              isLoading: false,
            ));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e, false, null));
        }
      },
    );
    on<AuthEventToLogIn>(
      (event, emit) {
        emit(const AuthStateLoggedOut(null, false, null));
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logout();
          emit(const AuthStateLoggedOut(null, false, null));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e, false, null));
        }
      },
    );
  }
}
