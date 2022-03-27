import 'exceptions.dart';
import 'provider.dart';
import 'user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FireBaseAuthProvider implements AuthProvider {
  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "weak-password":
          throw WeakPasswordException();
        case "email-already-in-use":
          throw EmailAlreadyInUseException();
        case "invalid-email":
          throw InvalidEmailException();
      }
      throw GenericAuthException();
    } catch (x) {
      rethrow;
    }
  }

  @override
  User? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    } else {
      return User.fromFirebase(user);
    }
  }

  @override
  Future<void> logout() async {
    final user = currentUser;
    if (user == null) {
      throw UserNotLoggedInException();
    }
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user == null) {
        throw UserNotLoggedInException();
      }
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          throw InvalidEmailException();
        case "user-not-found":
          throw UserNotFoundException();
        case "wrong-password":
          throw WrongPasswordException();
        default:
          throw GenericAuthException();
      }
    } catch (x) {
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }
}
