import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'note.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar _isar;
  // init database
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  // list of notes
  final List<Note> currentNotes = [];

  // create
  Future<void> addNote(String textFromUSer) async {
    final newNote = Note()..text = textFromUSer;
    await _isar.writeTxn((isar) async {
      await isar.notes.put(newNote);
    } as Future Function());

    fetchNotes();
  }

  // read
  Future<void> fetchNotes() async {
    List<Note> notes = await _isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(notes);
    notifyListeners();
  }

  // update
  Future<void> updateNote(String newText, int id) async {
    final note = await _isar.notes.get(id);
    if (note != null) {
      note.text = newText;
      await _isar.writeTxn(() => _isar.notes.put(note));
      await fetchNotes();
    }
  }

  // delete
  Future<void> deleteNotes(int id) async {
    await _isar.notes.delete(id);
    await fetchNotes();
  }
}
