import 'package:flutter/material.dart';
import 'package:notest/constants/routes.dart';
import 'package:notest/views/login_view.dart';
import 'package:notest/views/notes/create_update_note_view.dart';
import 'package:notest/views/notes/notes_view.dart';
import 'package:notest/views/register_view.dart';
import 'package:notest/views/verify_email_view.dart';

final Map<String, WidgetBuilder> routes = {
  loginRoute: (context) => const LoginView(),
  registerRoute: (context) => const RegisterView(),
  verifyEmailRoute: (context) => const VerifyEmailView(),
  notesRoute: (context) => const NotesView(),
  createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
};
