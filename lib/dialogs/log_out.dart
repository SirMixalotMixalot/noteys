import 'package:flutter/material.dart';
import 'generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialogWithBuilder<bool>(
      context: context,
      title: const Text("Log out?"),
      content: const Text("Are you sure you want to log out?"),
      optionBuilder: () => {
            const Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ): true,
            const Text("No"): false,
          }).then((v) => v ?? false);
}
