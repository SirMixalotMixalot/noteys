import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future showErrorDialog(BuildContext context, String text) {
  return showGenericDialogWithBuilder(
    context: context,
    title: const Text("An error occured"),
    content: Text(
      text,
      style: const TextStyle(
        color: Colors.redAccent,
      ),
    ),
    optionBuilder: () => {
      const Text('Ok'): null,
    },
  );
}
