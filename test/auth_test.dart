import 'package:noteys/services/auth/exceptions.dart';
import 'package:noteys/services/auth/provider.dart';
import 'package:noteys/services/auth/user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock authentication", () {
    final provider = MockProvider();
    test("Is not initially initialized",
        () => expect(provider.isInitialized, false));
    test("Can not logout without initialization", () {
      expect(
          provider.logout(), throwsA(const TypeMatcher<NotInitializedError>()));
    });
    test(
      "Initialized correctly",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(
        Duration(seconds: 2),
      ),
    );
    test("Create user delegates to logIn function", () async {
      expect(provider.createUser(email: "foo@bar.com", password: "aaaaaaaaa"),
          throwsA(const TypeMatcher<UserNotFoundException>()));
      final badPasswordUser =
          provider.createUser(email: 'someone@gmail.com', password: 'foobar');
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordException>()));
      final invalidPasswordUser = provider.createUser(
          email: 'doesntmatter@gmail.com', password: _createInvalidPassword());
      expect(invalidPasswordUser,
          throwsA(const TypeMatcher<WeakPasswordException>()));

      final user = await provider.createUser(
          email: 'b@gmail.com', password: _createValidPassword());
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test("Logged in user should be able to get verified", () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test("Should be able to log out and log in again", () async {
      await provider.logout();
      expect(provider.currentUser, isNull);
      await provider.login(email: 'blahblah', password: _createValidPassword());
      expect(provider.currentUser, isNotNull);
    });
  });
}

class NotInitializedError implements Exception {}

String _createValidPassword() {
  return 'abcdef';
}

String _createInvalidPassword() {
  return 'abcde';
}

bool _isValidPassword(String password) {
  return password.length >= 6;
}

class MockProvider implements AuthProvider {
  User? _user;
  bool _isInit = false;

  bool get isInitialized => _isInit;
  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedError();
    await Future.delayed(const Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  User? get currentUser => _user;

  @override
  Future<void> initialize() async {
    _isInit = true;
  }

  @override
  Future<User> login({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedError();
    if (email == 'foo@bar.com') throw UserNotFoundException();
    if (!_isValidPassword(password)) throw WeakPasswordException();
    if (password == 'foobar') throw WrongPasswordException();
    const user = User(isEmailVerified: false, email: 'geeewiz.com', id: '----');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedError();
    if (currentUser == null) throw UserNotFoundException();
    Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedError();
    if (currentUser == null) throw UserNotFoundException();
    _user = const User(isEmailVerified: true, email: 'geewiz.com', id: '-----');
  }
}
