import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<Text, T?> Function();
Future<T?> showGenericDialogWithBuilder<T>(
    {required BuildContext context,
    required Text title,
    required Text content,
    required DialogOptionBuilder<T> optionBuilder}) {
  final options = optionBuilder();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title,
          actions: options.keys.map(
            (optionTitle) {
              final value = options[optionTitle];
              return TextButton(
                  onPressed: () {
                    if (value != null) {
                      Navigator.of(context).pop(value);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: optionTitle);
            },
          ).toList(),
          content: content,
        );
      });
}

Future<T?> showGenericDialogWithActions<T>({
  required BuildContext context,
  required Text title,
  required Text content,
  required List<Widget> actions,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title,
          actions: actions,
          content: content,
        );
      });
}
