import 'package:flutter/material.dart';
import 'package:noteys/services/auth/service.dart';
import 'package:noteys/services/crud/db_note.dart';
import 'package:noteys/services/crud/notes.dart';
import 'package:noteys/utils/generics/get_args.dart';

class UpdateNoteView extends StatefulWidget {
  const UpdateNoteView({Key? key}) : super(key: key);

  @override
  State<UpdateNoteView> createState() => _UpdateNoteViewState();
}

class _UpdateNoteViewState extends State<UpdateNoteView> {
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

  Future<DBNote> createOrGetExistingNote() async {
    final widgetNote = context.getArgument<DBNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _controller.text = widgetNote.text;

      return widgetNote;
    }
    final note = _note;
    if (note != null) {
      return note;
    } else {
      //DONE: handle exceptions - idc
      final currentUser = AuthService.firebase().currentUser!;
      final owner = await _notesService.getUser(email: currentUser.email);
      final n = await _notesService.createNote(owner: owner);
      _note = n;
      return n;
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
          'Edit Note',
        ),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(),
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
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
