import 'package:noteys/services/auth/provider.dart';
import 'package:noteys/services/auth/user.dart';
import 'package:noteys/services/auth/firebase_auth.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FireBaseAuthProvider());
  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) async =>
      provider.createUser(email: email, password: password);

  @override
  User? get currentUser => provider.currentUser;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) {
    return provider.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return provider.logout();
  }

  @override
  Future<void> sendEmailVerification() {
    return provider.sendEmailVerification();
  }

  @override
  Future<void> initialize() {
    return provider.initialize();
  }
}
