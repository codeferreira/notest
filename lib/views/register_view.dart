import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notest/constants/routes.dart';
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
                final userCredentials =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                await userCredentials.user?.sendEmailVerification();

                if (!mounted) return;

                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (error) {
                if (error.code == 'weak-password') {
                  await showErrorDialog(
                    context,
                    'Password is too weak',
                  );
                } else if (error.code == 'invalid-email') {
                  await showErrorDialog(
                    context,
                    'Email has invalid format',
                  );
                } else if (error.code == 'email-already-in-use') {
                  await showErrorDialog(
                    context,
                    'Email is already in use',
                  );
                } else {
                  await showErrorDialog(
                    context,
                    'Error: ${error.code}',
                  );
                }
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
