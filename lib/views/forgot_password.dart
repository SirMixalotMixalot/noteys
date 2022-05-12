import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteys/services/auth/bloc/bloc.dart';
import 'package:noteys/services/auth/bloc/events.dart';
import 'package:noteys/services/auth/bloc/states.dart';
import 'package:noteys/utils/dialogs/error_dialog.dart';
import 'package:noteys/utils/dialogs/reset_password_sent.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              'Something went wrong with sending the email! Please make sure you are registered',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Column(children: [
          const Text('Enter you email'),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _controller,
            autocorrect: false,
            autofocus: true,
            decoration: const InputDecoration(
                hintText: 'Please enter your email address'),
          ),
          ElevatedButton(
            onPressed: () {
              final email = _controller.text;
              context
                  .read<AuthBloc>()
                  .add(AuthEventForgotPassword(email: email));
            },
            child: const Text(
              'Send me the password reset link',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventToLogIn());
            },
            child: const Text(
              'Send me back to the login page',
            ),
          ),
        ]),
      ),
    );
  }
}
