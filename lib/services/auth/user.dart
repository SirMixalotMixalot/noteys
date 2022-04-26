import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show User;
import 'package:meta/meta.dart';

@immutable
class User {
  final bool isEmailVerified;
  final String email;
  final String id;
  const User(
      {required this.isEmailVerified, required this.email, required this.id});

  factory User.fromFirebase(firebase_auth.User user) => User(
      isEmailVerified: user.emailVerified, email: user.email!, id: user.uid);
}
