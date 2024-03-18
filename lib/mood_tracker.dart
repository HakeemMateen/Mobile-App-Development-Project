import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MoodTracker extends StatefulWidget {
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  final TextEditingController _noteController = TextEditingController();
  List<String> _savedNotes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _noteController
        .dispose(); // Clean up the controller when the widget is removed
    super.dispose();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.txt');
  }

  Future<void> _saveNote() async {
    final note = _noteController.text;
    final file = await _localFile;
    await file.writeAsString('$note\n', mode: FileMode.append);
    setState(() {
      _savedNotes.add(note);
      _noteController.clear();
    });
  }

  Future<void> _loadNotes() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final notes =
          contents.split('\n').where((note) => note.isNotEmpty).toList();
      setState(() {
        _savedNotes = notes;
      });
    } catch (e) {
      // If encountering an error, return an empty list
      setState(() {
        _savedNotes = [];
      });
    }
  }

  Future<void> _deleteNote(int index) async {
    _savedNotes.removeAt(index);
    final file = await _localFile;
    await file.writeAsString(_savedNotes.join('\n') + '\n');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
                'How are you feeling today?'), // Placeholder for mood selection UI
            SizedBox(height: 20),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Enter your notes here',
                border: OutlineInputBorder(),
                hintText: 'I felt ...',
              ),
              maxLines: null, // Allows input to wrap to new line on enter
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveNote();
              },
              child: Text('Save Note'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _savedNotes.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text('Note ${index + 1}'),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(_savedNotes[index])),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteNote(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
