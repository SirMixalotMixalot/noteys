import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';
import 'db_note.dart';
import 'exceptions.dart';
import 'db_user.dart';

class NotesService {
  Database? _db;
  Future<List<Map<String, Object?>>> queryUser(String email) async {
    final db = _getDataBaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email],
    );
    return results;
  }

  Future<DBNote> updateNote({
    required DBNote note,
    required String text,
  }) async {
    final db = _getDataBaseOrThrow();

    await getNote(id: note.id);

    final updatesCount = await db.update(notesTable, {
      textColumn: text,
      isSyncedColumn: 0,
    });
    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      return DBNote(
        id: note.id,
        userId: note.userId,
        text: text,
        isSynchedWithCloud: false,
      );
    }
  }

  Future deleteAllNotesBy({required int userId}) async {
    final db = _getDataBaseOrThrow();
    await db.delete(
      notesTable,
      where: '$userIdColumn = ?',
      whereArgs: [userId],
    );
  }

  Future<Iterable<DBNote>> getAllNotes() async {
    final db = _getDataBaseOrThrow();
    final results = await db.query(notesTable);
    return results.map(DBNote.fromRow);
  }

  Future<DBNote> getNote({required int id}) async {
    final db = _getDataBaseOrThrow();
    final results =
        await db.query(notesTable, where: '$idColumn = ?', whereArgs: [id]);
    if (results.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DBNote.fromRow(results.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDataBaseOrThrow();
    return await db.delete(notesTable);
  }

  Future deleteNote({required int id}) async {
    final db = _getDataBaseOrThrow();
    final deletedCount = await db.delete(
      notesTable,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DBNote> createNote({required DBUser owner}) async {
    final db = _getDataBaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw UserDoesNotExist();
    }
    const text = '';
    final id = await db.insert(notesTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedColumn: 1,
    });
    return DBNote(
      id: id,
      userId: owner.id,
      text: text,
      isSynchedWithCloud: true,
    );
  }

  Future<DBUser> getUser({required String email}) async {
    email = email.toLowerCase();
    final results = await queryUser(email);
    if (results.isEmpty) {
      throw UserDoesNotExist();
    } else {
      return DBUser.fromRow(results.first);
    }
  }

  Future<DBUser> createUser({required String email}) async {
    email = email.toLowerCase();
    final db = _getDataBaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final id = await db.insert(userTable, {
      emailColumn: email,
    });
    return DBUser(
      id: id,
      email: email,
    );
  }

  //throws: DataBaseAlreadyOpenException
  Future open() async {
    if (_db != null && _db!.isOpen) {
      throw DataBaseAleadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);

      _db = await openDatabase(dbPath);

      await _db?.execute(createUserTable);

      await _db?.execute(createNotesTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }

  Future close() async {
    if (_db == null || !_db!.isOpen) {
      throw DataBaseIsNotOpenException();
    }
    await _db!.close();
    _db = null;
  }

  Future deleteUser({required String email}) async {
    final db = _getDataBaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteUser();
    } else if (deletedCount != 1) {
      //undelete
    }
  }

  Database _getDataBaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpenException();
    } else {
      return db;
    }
  }
}
