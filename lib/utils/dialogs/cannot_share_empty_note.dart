import 'generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialogWithBuilder(
    context: context,
    title: const Text('Sharing'),
    content: const Text('You cannot share an empty note'),
    optionBuilder: () => {
      const Text('Ok'): null,
    },
  );
}
