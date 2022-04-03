import 'constants.dart';

class DBNote {
  final int id;
  final int userId;
  final String text;
  final bool isSynchedWithCloud;

  const DBNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSynchedWithCloud,
  });
  DBNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSynchedWithCloud = map[isSyncedColumn] as int == 1;
  @override
  bool operator ==(covariant DBNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
