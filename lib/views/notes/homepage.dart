import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteys/constants/routes.dart';
import 'package:noteys/services/auth/bloc/bloc.dart';
import 'package:noteys/services/auth/bloc/events.dart';
import 'package:noteys/services/cloud/firebase_cloud_storage.dart';
import 'package:noteys/services/cloud/note.dart';
import 'package:noteys/utils/dialogs/log_out.dart';
import 'package:noteys/services/auth/service.dart';
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
  String get userId => AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorage _notesService;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
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
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
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
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerId: userId),
        builder: (context, notesSnapshot) {
          switch (notesSnapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              if (notesSnapshot.hasData) {
                final allNotes = notesSnapshot.data as Iterable<CloudNote>;
                return NotesList(
                  allNotes: allNotes,
                  onDelete: (note) async {
                    _notesService.deleteNote(
                      documentId: note.id,
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
      ),
    );
  }
}
