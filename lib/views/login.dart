import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:noteys/constants/routes.dart';
import 'package:noteys/services/auth/exceptions.dart';
import 'package:noteys/services/auth/service.dart';
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
    final service = AuthService.firebase();
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
                final user = await service.login(
                  email: email,
                  password: password,
                );
                if (!user.isEmailVerified) {
                  Navigator.of(context).pushNamed(verifyRoute);
                  return;
                }

                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesRoute, (route) => false);
              } on UserNotFoundException {
                await showErorDialog(
                  context,
                  'User was not found!',
                );
              } on WrongPasswordException {
                await showErorDialog(
                  context,
                  'Incorrect Password',
                );
              } on GenericAuthException {
                await showErorDialog(context, 'Authentication error');
              } catch (x) {
                devtools.log("Unhandled exception!!");
                devtools.log(x.toString());
              } finally {
                _password.clear();
                _email.clear();
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
