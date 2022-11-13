import 'package:flutter/material.dart';
import 'package:notest/constants/routes.dart';
import 'package:notest/services/auth/auth_expections.dart';
import 'package:notest/services/auth/auth_service.dart';
import 'package:notest/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
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
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().register(
                  email: email,
                  password: password,
                );

                await AuthService.firebase().sendEmailVerification();

                if (!mounted) return;

                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Password is too weak',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Email has invalid format',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email is already in use',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Unknow register error',
                );
              } catch (error) {
                await showErrorDialog(
                  context,
                  'Error: ${error.toString()}',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already have an accou? Login here'),
          )
        ],
      ),
    );
  }
}
