import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noteys/services/cloud/constants.dart';
import 'package:noteys/services/cloud/exceptions.dart';
import 'package:noteys/services/cloud/note.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<CloudNote> createNewNote({required String ownerId}) async {
    try {
      final document = await notes.add({
        ownerIdField: ownerId,
        textField: '',
      });
      final fetchedNote = await document.get();
      return CloudNote(
        id: fetchedNote.id,
        ownerId: ownerId,
        text: '',
      );
    } catch (_) {
      throw CouldNotCreateNote();
    }
  }

  void deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNote();
    }
  }

  Future updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({
        textField: text,
      });
    } catch (_) {
      throw CouldNotUpdateNote();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerId}) {
    return notes.snapshots().map((event) => event.docs
        .map(CloudNote.fromSnap)
        .where((note) => note.ownerId == ownerId));
  }

  Future<Iterable<CloudNote>> getAllNotesBy({required String ownerId}) async {
    try {
      return await notes
          .where(ownerIdField, isEqualTo: ownerId)
          .get()
          .then((value) => value.docs.map(
                CloudNote.fromSnap,
              ));
    } catch (e) {
      throw CouldNotGetAllNotes();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
