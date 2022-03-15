import 'package:flutter/material.dart';

import "package:firebase_auth/firebase_auth.dart";

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late List<InputDecoration> _emailDecor;
  late List<InputDecoration> _passwordDecor;
  bool emailError = false;
  bool passwordError = false;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _emailDecor = [
      const InputDecoration(
        hintText: "Enter your email here",
      ),
      const InputDecoration()
    ];
    _passwordDecor = [
      const InputDecoration(
        hintText: "Enter your email's password here",
      ),
      const InputDecoration()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: _emailDecor[emailError ? 1 : 0],
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: _passwordDecor[passwordError ? 1 : 0],
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              if (email.isEmpty) {
                _emailDecor[1] =
                    const InputDecoration(errorText: 'Please enter an email');
                emailError = true;
                return;
              }
              if (password.isEmpty) {
                _passwordDecor[1] =
                    const InputDecoration(errorText: 'Please enter a password');
                passwordError = true;

                return;
              }
              try {
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                emailError = false;
                passwordError = false;

                print(userCredential);
              } on FirebaseAuthException catch (e) {
                print(e.code);
                if (e.code == 'weak-password') {
                  _passwordDecor[1] = const InputDecoration(
                    errorText: 'Password is too weak',
                  );
                  passwordError = true;
                } else if (e.code == 'email-already-in-use') {
                  _emailDecor[1] = const InputDecoration(
                    errorText: 'Email in use',
                  );
                  emailError = true;
                } else if (e.code == 'invalid-email') {
                  _emailDecor[1] = const InputDecoration(
                    errorText: 'Email is invalid',
                  );
                  emailError = true;
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text("Already Registered? Sign in here!"))
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
