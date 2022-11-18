import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notest/services/auth/auth_provider.dart';
import 'package:notest/services/auth/bloc/auth_event.dart';
import 'package:notest/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();

      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(null));
        return;
      }

      if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
        return;
      }

      emit(AuthStateLoggedIn(user));
    });

    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);

        emit(AuthStateLoggedIn(user));
      } on Exception catch (error) {
        emit(AuthStateLoggedOut(error));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateLoading());

        await provider.logOut();

        emit(const AuthStateLoggedOut(null));
      } on Exception catch (error) {
        emit(AuthStateLogOutFailure(error));
      }
    });
  }
}
