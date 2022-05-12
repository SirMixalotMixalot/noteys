import 'package:noteys/services/auth/user.dart';

abstract class AuthProvider {
  User? get currentUser;
  Future<User> login({
    required String email,
    required String password,
  });
  Future<User> createUser({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<void> initialize();
  Future<void> sendPasswordResetEmail({required String email});
}
