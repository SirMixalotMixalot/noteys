import 'package:flutter/material.dart';
import 'package:noteys/dialogs/delete_note.dart';
import 'package:noteys/services/crud/db_note.dart';

typedef DeleteNoteCallBack = void Function(DBNote note);

class NotesList extends StatelessWidget {
  final List<DBNote> allNotes;
  final DeleteNoteCallBack onDelete;
  const NotesList({
    Key? key,
    required this.allNotes,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(9.0),
            child: ListTile(
              title: Text('✏️ Note #${index + 1}'),
              subtitle: Text(
                allNotes[index].text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDelete(allNotes[index]);
                  }
                },
              ),
            ),
          );
        },
        itemCount: allNotes.length,
      ),
    );
  }
}
