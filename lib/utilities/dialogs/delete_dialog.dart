import 'package:flutter/cupertino.dart';
import 'package:notest/utilities/dialogs/generic_diolog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete note',
    content: 'Are you sure you want to delete this note?',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
