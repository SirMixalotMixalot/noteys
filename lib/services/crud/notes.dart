import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';
import 'db_note.dart';
import 'exceptions.dart';
import 'db_user.dart';

class NotesService {
  Database? _db;

  List<DBNote> _notes = [];
  final _noteStreamController = StreamController<List<DBNote>>.broadcast();
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

  Future _cacheNotes() async {
    final notes = await getAllNotes();
    _updatesNotes(() => _notes = notes.toList());
  }

  Future<DBNote> updateNote({
    required DBNote note,
    required String text,
  }) async {
    final db = _getDataBaseOrThrow();

    await getNote(id: note.id);

    final updatesCount = await db.update(
      notesTable,
      {
        textColumn: text,
        isSyncedColumn: 0,
      },
      where: '$idColumn = ?',
      whereArgs: [note.id],
    );
    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = DBNote(
        id: note.id,
        userId: note.userId,
        text: text,
        isSynchedWithCloud: false,
      );
      final index = _notes.indexWhere((element) => element.id == note.id);
      if (index < 0) {
        //should never happen since we  are updating a note
        //but in the off chance it does occur
        log("Adding an updated note to the cache ???");
        _updatesNotes(() => _notes.add(updatedNote));
      } else {
        _updatesNotes(() {
          _notes[index] = updatedNote;
        });
      }
      return updatedNote;
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

  void _updatesNotes(Function mutateNotes) {
    mutateNotes();
    _noteStreamController.add(_notes);
  }

  Future<DBNote> getNote({required int id}) async {
    //notes could be updated and no good way to check if a
    //note was updated without going to the database
/*     final matchingNotes = _notes.where((note) => note.id == id);
    final noteCached = matchingNotes.isNotEmpty;
    if (noteCached) {
      return matchingNotes.first;
    } */
    final db = _getDataBaseOrThrow();
    final results = await db.query(
      notesTable,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DBNote.fromRow(results.first);

      _updatesNotes(() {
        final index = _notes.indexWhere((n) => n.id == id);
        if (index < 0) {
          _notes.add(note);
        } else {
          _notes[index] = note;
        }
      });
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDataBaseOrThrow();
    _updatesNotes(() => _notes = []);
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
    } else {
      _updatesNotes(
        () => _notes.removeWhere((note) => note.id == id),
      );
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
    final note = DBNote(
      id: id,
      userId: owner.id,
      text: text,
      isSynchedWithCloud: true,
    );
    _updatesNotes(() => _notes.add(note));
    return note;
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

  Future<DBUser> getOrCreateUser({required String email}) async {
    try {
      return await getUser(email: email);
    } on UserDoesNotExist {
      return await createUser(email: email);
    } catch (e) {
      rethrow;
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
      await _cacheNotes();
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
