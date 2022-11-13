import 'package:firebase_core/firebase_core.dart';
import 'package:notest/firebase_options.dart';
import 'package:notest/services/auth/auth_user.dart';
import 'package:notest/services/auth/auth_provider.dart';
import 'package:notest/services/auth/auth_expections.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return AuthUser.fromFirebase(user);
    }

    return null;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;

      if (user != null) {
        return user;
      }

      throw UserNotLoggedInAuthException();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      }

      if (error.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      }

      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseAuth.instance.signOut();
      return;
    }

    throw UserNotLoggedInAuthException();
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;

      if (user != null) {
        return user;
      }

      throw UserNotLoggedInAuthException();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        throw WeakPasswordAuthException();
      }

      if (error.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      }

      if (error.code == 'email-already-in-use') {
        throw InvalidEmailAuthException();
      }

      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.sendEmailVerification();
      return;
    }

    throw UserNotLoggedInAuthException();
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
