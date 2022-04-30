import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:noteys/services/auth/bloc/bloc.dart';
import 'package:noteys/services/auth/bloc/events.dart';

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
              context.read<AuthBloc>().add(
                    const AuthEventSendVerifyEmail(),
                  );
            },
          ),
          TextButton(
            child: const Text("Return to login page"),
            onPressed: () => context.read<AuthBloc>().add(
                  const AuthEventToLogIn(),
                ),
          )
        ],
      ),
    );
  }
}
