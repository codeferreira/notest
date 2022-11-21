import 'package:flutter/material.dart';
import 'package:notest/constants/routes.dart';
import 'package:notest/views/notes/create_update_note_view.dart';

final Map<String, WidgetBuilder> routes = {
  createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
};
