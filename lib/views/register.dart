import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:noteys/constants/routes.dart';
import 'package:noteys/utils/errors.dart';

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
            onChanged: (_) => setState(() {}),
          ),
          TextField(
            controller: _password,
            decoration: _passwordDecor[passwordError ? 1 : 0],
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            onChanged: (_) => setState(() {}),
          ),
          ElevatedButton(
            onPressed: (_email.text.isEmpty || _password.text.isEmpty)
                ? null
                : () async {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      emailError = false;
                      passwordError = false;
                      await FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                      Navigator.of(context).pushNamed(verifyRoute);
                    } on FirebaseAuthException catch (e) {
                      showErorDialog(context, "Error: ${e.code}");
                      _email.clear();
                      _password.clear();
                    }
                  },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
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
