/* import 'package:flutter/foundation.dart';

import 'constants.dart';

@immutable
class DBUser {
  final int id;
  final String email;

  const DBUser({
    required this.id,
    required this.email,
  });
  DBUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;
  @override
  String toString() => 'Person {id = $id, email = $email}';

  @override
  bool operator ==(covariant DBUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
 */