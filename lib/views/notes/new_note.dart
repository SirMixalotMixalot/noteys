import 'package:flutter/material.dart';
import 'package:noteys/services/auth/service.dart';
import 'package:noteys/services/crud/db_note.dart';
import 'package:noteys/services/crud/notes.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DBNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _controller;

  @override
  void initState() {
    _notesService = NotesService();
    _controller = TextEditingController();
    super.initState();
  }

  void onTextChanged() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _controller.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setupController() {
    _controller.addListener(onTextChanged);
  }

  Future<DBNote> createNewNote() async {
    final note = _note;
    if (note != null) {
      return note;
    } else {
      //TODO: handle exceptions
      final currentUser = AuthService.firebase().currentUser!;
      final owner = await _notesService.getUser(email: currentUser.email);
      return await _notesService.createNote(owner: owner);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final note = _note;
    final text = _controller.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() async {
    _controller.dispose();
    super.dispose();
    final note = _note;
    if (_controller.text.isEmpty && note != null) {
      await _notesService.deleteNote(id: note.id);
    } else {
      _saveNoteIfNotEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Note',
        ),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DBNote;
              _setupController();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Notes away...",
                    border: InputBorder.none,
                  ),
                ),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
