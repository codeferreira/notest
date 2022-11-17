import 'package:flutter/cupertino.dart';
import 'package:notest/utilities/dialogs/generic_diolog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
