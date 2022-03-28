import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:noteys/constants/routes.dart';
import 'package:noteys/services/auth/service.dart';

import 'views/register.dart';
import 'views/login.dart';
import 'views/verify_email.dart';
import 'views/notes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Notey());
}

class Notey extends StatelessWidget {
  const Notey({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterView(),
        verifyRoute: (context) => const VerifyEmailPage(),
        notesRoute: (context) => const NotesView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = AuthService.firebase();
    return FutureBuilder(
      future: service.initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = service.currentUser;
            final noUser = user == null;
            if (!noUser && !user.isEmailVerified) {
              devtools.log(user.toString());
              return const VerifyEmailPage();
            }
            if (!noUser) {
              return const NotesView();
            }
            return const LoginPage();
          default:
            return Scaffold(
              appBar: AppBar(
                title: const Text("Loading..."),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
