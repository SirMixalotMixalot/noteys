import 'package:flutter/material.dart';
import 'package:noteys/constants/routes.dart';
import 'package:noteys/utils/dialogs/log_out.dart';
import 'package:noteys/services/auth/service.dart';
import 'package:noteys/services/crud/db_note.dart';

import 'package:noteys/services/crud/notes.dart';
import 'package:noteys/views/notes/notes_list.dart';

enum MenuAction {
  logout,
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email;
  late final NotesService _notesService;
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes 🗒️"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(editNoteRoute);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    await AuthService.firebase().logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log out"),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, notesSnapshot) {
                  switch (notesSnapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      if (notesSnapshot.hasData) {
                        final allNotes = notesSnapshot.data as List<DBNote>;
                        return NotesList(
                          allNotes: allNotes,
                          onDelete: (note) async {
                            await _notesService.deleteNote(
                              id: note.id,
                            );
                          },
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              editNoteRoute,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },
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
