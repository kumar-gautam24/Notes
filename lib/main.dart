import 'package:flutter/material.dart';
import 'package:notes/models/note_database.dart';
import 'package:notes/views/NotesScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialise notes
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesScreen(),
    );
  }
}
