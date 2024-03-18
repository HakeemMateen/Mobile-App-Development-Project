import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'notes_service.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    NotesService().loadNotesForDate(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              NotesService().loadNotesForDate(selectedDay);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              NotesService().loadNotesForDate(focusedDay);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: NotesService()
                      .savedNotes[_selectedDay ?? _focusedDay]
                      ?.length ??
                  0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Note ${index + 1}'),
                  subtitle: Text(NotesService()
                          .savedNotes[_selectedDay ?? _focusedDay]?[index] ??
                      ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      NotesService()
                          .deleteNote(_selectedDay ?? _focusedDay, index);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('How are you feeling today?'),
                content: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: 'Enter your thoughts here',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      NotesService().saveNote(
                        _selectedDay ?? _focusedDay,
                        _noteController.text,
                      );
                      _noteController.clear();
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
