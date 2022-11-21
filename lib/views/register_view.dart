import 'package:flutter/material.dart';
import 'package:notest/constants/routes.dart';
import 'package:notest/services/auth/auth_exceptions.dart';
import 'package:notest/services/auth/auth_service.dart';
import 'package:notest/services/auth/bloc/auth_bloc.dart';
import 'package:notest/services/auth/bloc/auth_event.dart';
import 'package:notest/services/auth/bloc/auth_state.dart';
import 'package:notest/utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void handleRegister(BuildContext context) {
    final email = _email.text;
    final password = _password.text;

    context
        .read<AuthBloc>()
        .add(AuthEventRegister(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          //  if (!state.isLoading && closeDialog != null) {
          //   closeDialog();
          //   _closeDialogHandle = null;
          //   return;
          // }

          // if (state.isLoading && closeDialog == null) {
          //   _closeDialogHandle = showLoadingDialog(
          //     context: context,
          //     text: 'Loading...',
          //   );
          // }

          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              'Weak password',
            );
            return;
          }

          if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              'Email is already in use',
            );
            return;
          }

          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'Invalid email',
            );
            return;
          }

          if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Failed to register',
            );
            return;
          }
        }
      },
      child: Scaffold(
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
              decoration:
                  const InputDecoration(hintText: 'Enter your password'),
            ),
            TextButton(
              onPressed: () => handleRegister(context),
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text('Already have an accou? Login here'),
            )
          ],
        ),
      ),
    );
  }
}
