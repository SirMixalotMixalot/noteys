import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import "package:firebase_auth/firebase_auth.dart";
import 'firebase_options.dart';

import 'views/register.dart';
import 'views/login.dart';

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
      home: const RegisterView(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null && !user.emailVerified) {
                user.sendEmailVerification();
              }
              return const Text("Firebase initialized! 🤩🥳🥳🥳");
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
