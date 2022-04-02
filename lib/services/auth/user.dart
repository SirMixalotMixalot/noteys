import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show User;
import 'package:meta/meta.dart';

@immutable
class User {
  final bool isEmailVerified;
  const User({required this.isEmailVerified});

  factory User.fromFirebase(firebase_auth.User user) =>
      User(isEmailVerified: user.emailVerified);
}
