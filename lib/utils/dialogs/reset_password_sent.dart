import 'package:flutter/cupertino.dart';
import 'package:noteys/utils/dialogs/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialogWithBuilder(
    context: context,
    title: const Text('Password reset'),
    content: const Text('Password reset link sent to email. Check your inbox'),
    optionBuilder: () => {
      const Text('Ok'): null,
    },
  );
}
