/* import 'dart:async';
import 'dart:developer';

import 'package:noteys/extensions/filter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';
import 'db_note.dart';
import 'exceptions.dart';
import 'db_user.dart'; */

/* class NotesService {
  Database? _db;
  DBUser? _user;
  NotesService._sharedInstance() {
    _noteStreamController = StreamController<List<DBNote>>.broadcast(
      onListen: () {
        _noteStreamController.sink.add(_notes);
      },
    );
  }

  static final NotesService _shared = NotesService._sharedInstance();
  factory NotesService() => _shared;
  List<DBNote> _notes = [];
  late final StreamController<List<DBNote>> _noteStreamController;
  Future<List<Map<String, Object?>>> queryUser(String email) async {
    final db = await _getDataBaseOrOpen();
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
    _updatesNotes(() => _notes = (notes.toList()));
  }

  Future<DBNote> updateNote({
    required DBNote note,
    required String text,
  }) async {
    final db = await _getDataBaseOrOpen();

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
    final db = await _getDataBaseOrOpen();
    await db.delete(
      notesTable,
      where: '$userIdColumn = ?',
      whereArgs: [userId],
    );
  }

  Stream<List<DBNote>> get allNotes =>
      _noteStreamController.stream.filter((note) {
        final currentUser = _user;
        if (currentUser == null) {
          throw UserShouldBeDefined();
        } else {
          return note.userId == currentUser.id;
        }
      });
  Future<Iterable<DBNote>> getAllNotesBy({required DBUser user}) async {
    final db = await _getDataBaseOrOpen();

    final results = await db.query(
      notesTable,
      where: '$idColumn = ?',
      whereArgs: [user.id],
    );
    return results.map(DBNote.fromRow);
  }

  Future<Iterable<DBNote>> getAllNotes() async {
    final db = await _getDataBaseOrOpen();
    return (await db.query(notesTable)).map(DBNote.fromRow);
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
    final db = await _getDataBaseOrOpen();
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

  //TODO: evaluate the usefulness of this function
  Future<int> deleteAllNotes() async {
    final db = await _getDataBaseOrOpen();
    _updatesNotes(() => _notes = []);
    return await db.delete(notesTable);
  }

  Future deleteNote({required int id}) async {
    final db = await _getDataBaseOrOpen();
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
    final db = await _getDataBaseOrOpen();
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

  Future<DBUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    DBUser user;
    try {
      user = await getUser(email: email);
    } on UserDoesNotExist {
      user = await createUser(email: email);
    } catch (e) {
      rethrow;
    }
    if (setAsCurrentUser) {
      _user = user;
    }

    return user;
  }

  Future<DBUser> createUser({required String email}) async {
    email = email.toLowerCase();
    final db = await _getDataBaseOrOpen();
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

      final db = await openDatabase(dbPath);

      await db.execute(createUserTable);

      await db.execute(createNotesTable);
      _db = db;
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
    final db = await _getDataBaseOrOpen();
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

  Future<Database> _getDataBaseOrOpen() async {
    final db = _db;
    if (db == null || !db.isOpen) {
      await open();
    }

    return _db!;
  }
} */
