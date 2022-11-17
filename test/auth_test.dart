import 'package:notest/services/auth/auth_exceptions.dart';
import 'package:notest/services/auth/auth_provider.dart';
import 'package:notest/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication:', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Sould not log out before initialization', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();

      expect(provider.isInitialized, true);
    });

    test('User should be null after initialize', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should throw UserNotFound exception with foo@bar.com email',
      () async {
        final badEmailUser = provider.register(
          email: 'foo@bar.com',
          password: 'anypassword',
        );

        expect(
          badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()),
        );
      },
    );

    test(
      'Should throw WrongPassword exception with foobar password',
      () async {
        final badPasswordUser = provider.register(
          email: 'any@mail.com',
          password: 'foobar',
        );

        expect(
          badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()),
        );
      },
    );

    test('Should create user and isEmailVerified should be false', () async {
      final user = await provider.register(
        email: 'any@mail.com',
        password: 'anypassword',
      );

      expect(
        provider.currentUser,
        user,
      );

      expect(user.isEmailVerified, false);
    });

    test(
      'Should verify set isEmailVerified to true when call sendEmailVerification',
      () async {
        await provider.sendEmailVerification();

        expect(provider.currentUser?.isEmailVerified, true);
      },
    );

    test('User should be null after log out', () async {
      await provider.logOut();

      expect(provider.currentUser, null);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();

    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();

    const user =
        AuthUser(isEmailVerified: false, email: 'foo@bar.com', id: 'my_id');

    _user = user;

    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();

    if (_user == null) throw UserNotFoundAuthException();

    await Future.delayed(const Duration(seconds: 1));

    _user = null;
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();

    await Future.delayed(const Duration(seconds: 1));

    return logIn(email: email, password: password);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();

    final user = _user;

    if (user == null) throw UserNotFoundAuthException();

    const newUser = AuthUser(isEmailVerified: true, email: '', id: 'my_id');

    _user = newUser;
  }
}
