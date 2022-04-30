import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteys/services/auth/bloc/bloc.dart';
import 'package:noteys/services/auth/bloc/events.dart';
import 'package:noteys/services/auth/bloc/states.dart';
import 'package:noteys/utils/dialogs/error_dialog.dart';
import 'package:noteys/services/auth/exceptions.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseException) {
            await showErrorDialog(context, 'User already exists');
          } else if (state.exception is InvalidEmailException) {
            await showErrorDialog(context, 'Invalid email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Error occured during registration');
          }
        }
      },
      child: Scaffold(
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
                      context.read<AuthBloc>().add(
                            AuthEventRegister(
                              email: email,
                              password: password,
                            ),
                          );
                    },
              child: const Text("Register"),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventToLogIn());
                },
                child: const Text("Already Registered? Sign in here!"))
          ],
        ),
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
