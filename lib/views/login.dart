import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import "package:firebase_auth/firebase_auth.dart";
import 'package:noteys/constants/routes.dart';
import '../utils/errors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(
              hintText: "Enter your email here",
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
              hintText: "Enter your email's password here",
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              if (email.isEmpty || password.isEmpty) {
                return;
              }
              try {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                if (!userCredential.user!.emailVerified) {
                  Navigator.of(context).pushNamed(verifyRoute);
                  return;
                }

                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesRoute, (route) => false);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case "user-not-found":
                    await showErorDialog(
                      context,
                      'User was not found!',
                    );
                    break;
                  case "wrong-password":
                    await showErorDialog(
                      context,
                      'Incorrect Password',
                    );
                    break;
                  case "invalid-email":
                    await showErorDialog(
                      context,
                      "Invalid email!",
                    );
                    break;
                  default:
                    devtools.log("Unhandled exception");
                    devtools.log(e.code);
                    break;
                }
                _email.clear();
                _password.clear();
              }
            },
            child: const Text("Log In"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (_) => false);
            },
            child: const Text("Not Registered? Register here"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
