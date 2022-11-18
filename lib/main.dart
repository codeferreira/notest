import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notest/routes/routes.dart';
import 'package:notest/services/auth/bloc/auth_bloc.dart';
import 'package:notest/services/auth/bloc/auth_event.dart';
import 'package:notest/services/auth/bloc/auth_state.dart';
import 'package:notest/services/auth/firebase_auth_provider.dart';
import 'package:notest/views/login_view.dart';
import 'package:notest/views/notes/notes_view.dart';
import 'package:notest/views/verify_email_view.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: routes,
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        }

        if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        }

        if (state is AuthStateLoggedOut) {
          return const LoginView();
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
