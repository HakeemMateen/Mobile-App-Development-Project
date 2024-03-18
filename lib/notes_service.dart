import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NotesService {
  static final NotesService _instance = NotesService._internal();
  Map<DateTime, List<String>> savedNotes = {};

  factory NotesService() {
    return _instance;
  }

  NotesService._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(DateTime date) async {
    final path = await _localPath;
    return File('$path/${date.toString().split(' ')[0]}.txt');
  }

  Future<void> loadNotesForDate(DateTime date) async {
    try {
      final file = await _localFile(date);
      final contents = await file.readAsString();
      final notes =
          contents.split('\n').where((note) => note.isNotEmpty).toList();
      savedNotes[date] = notes;
    } catch (e) {
      savedNotes[date] = [];
    }
  }

  Future<void> saveNote(DateTime date, String note) async {
    final file = await _localFile(date);
    await file.writeAsString('$note\n', mode: FileMode.append);
    await loadNotesForDate(date);
  }

  Future<void> deleteNote(DateTime date, int index) async {
    savedNotes[date]?.removeAt(index);
    final file = await _localFile(date);
    await file.writeAsString(savedNotes[date]?.join('\n') ?? '');
    await loadNotesForDate(date);
  }
}
