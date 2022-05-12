import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:noteys/constants/routes.dart';
import 'package:noteys/helpers/loading/loading_screen.dart';
import 'package:noteys/services/auth/bloc/bloc.dart';
import 'package:noteys/services/auth/bloc/events.dart';
import 'package:noteys/services/auth/bloc/states.dart';
import 'package:noteys/services/auth/firebase_auth.dart';
import 'package:noteys/views/forgot_password.dart';
import 'package:noteys/views/notes/edit_note.dart';

import 'views/register.dart';
import 'views/login.dart';
import 'views/verify_email.dart';
import 'views/notes/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const Notey(),
  );
}

class Notey extends StatelessWidget {
  const Notey({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noteys',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: BlocProvider(
        create: (context) => AuthBloc(FireBaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        editNoteRoute: (context) => const UpdateNoteView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialized());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Unreachable',
          );
        }
      },
      builder: ((context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateShouldVerify) {
          return const VerifyEmailPage();
        } else if (state is AuthStateLoggedOut) {
          return const LoginPage();
        } else if (state is AuthStateNotRegistered) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPassword();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
    );
  }
}
