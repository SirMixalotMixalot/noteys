import 'package:flutter/material.dart';

import "package:firebase_auth/firebase_auth.dart";
import 'package:noteys/constants/routes.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Page")),
      body: Column(
        children: [
          const Text('Please verify your email address'),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.currentUser?.sendEmailVerification();
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            child: const Text("Return to login page"),
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil(loginRoute, (_) => false),
          )
        ],
      ),
    );
  }
}
