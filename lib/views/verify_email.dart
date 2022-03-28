import 'package:flutter/material.dart';

import 'package:noteys/constants/routes.dart';
import 'package:noteys/services/auth/service.dart';
import 'package:noteys/utils/errors.dart';

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
          const Text('Please check your email for a verification email'),
          TextButton(
            child: const Text("Click here to resend"),
            onPressed: () async {
              try {
                await AuthService.firebase().sendEmailVerification();
              } catch (e) {
                showErorDialog(context, "Error: ${e.toString()}");
              }
            },
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
