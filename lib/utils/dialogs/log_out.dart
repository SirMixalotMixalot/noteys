import 'package:flutter/material.dart';
import 'generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialogWithBuilder<bool>(
      context: context,
      title: const Text("Log out?"),
      content: const Text("Are you sure you want to log out?"),
      optionBuilder: () => {
            const Text("No"): false,
            const Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ): true,
          }).then((v) => v ?? false);
}
