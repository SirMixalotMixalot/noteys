import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialogWithBuilder<bool>(
      context: context,
      title: const Text("Delete a Note"),
      content: const Text("Are you sure you'd like to delete this note?"),
      optionBuilder: () => {
            const Text("Cancel"): false,
            const Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ): true,
          }).then(
    (value) => value ?? false,
  );
}
