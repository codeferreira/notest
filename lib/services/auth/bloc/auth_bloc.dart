import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notest/services/auth/auth_provider.dart';
import 'package:notest/services/auth/bloc/auth_event.dart';
import 'package:notest/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();

      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        return;
      }

      if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
        return;
      }

      emit(AuthStateLoggedIn(
        user: user,
        isLoading: false,
      ));
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Wait while I log you in...',
        ),
      );

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);

        emit(const AuthStateLoggedOut(exception: null, isLoading: false));

        if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
          return;
        }

        emit(AuthStateLoggedIn(user: user, isLoading: false));
      } on Exception catch (error) {
        emit(AuthStateLoggedOut(exception: error, isLoading: false));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();

        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (error) {
        emit(AuthStateLoggedOut(exception: error, isLoading: false));
      }
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.register(email: email, password: password);

        await provider.sendEmailVerification();

        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (error) {
        emit(AuthStateRegistering(exception: error, isLoading: false));
      }
    });
  }
}
