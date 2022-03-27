import 'package:noteys/services/auth/provider.dart';
import 'package:noteys/services/auth/user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

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
}
