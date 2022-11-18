import 'package:flutter/material.dart';
import 'package:notest/constants/routes.dart';
import 'package:notest/services/auth/auth_exceptions.dart';
import 'package:notest/services/auth/bloc/auth_bloc.dart';
import 'package:notest/services/auth/bloc/auth_event.dart';
import 'package:notest/services/auth/bloc/auth_state.dart';
import 'package:notest/utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    final email = _email.text;
    final password = _password.text;

    context
        .read<AuthBloc>()
        .add(AuthEventLogIn(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is UserNotFoundAuthException) {
                  await showErrorDialog(
                    context,
                    'User not found',
                  );
                  return;
                }

                if (state.exception is WrongPasswordAuthException) {
                  await showErrorDialog(
                    context,
                    'Email or Password is incorrect',
                  );
                  return;
                }

                if (state.exception is GenericAuthException) {
                  await showErrorDialog(
                    context,
                    'Authentication error',
                  );
                  return;
                }
              }
            },
            child: TextButton(
              onPressed: handleLogin,
              child: const Text('Login'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Register here'),
          ),
        ],
      ),
    );
  }
}
