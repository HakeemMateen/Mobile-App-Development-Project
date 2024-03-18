import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'home_screen.dart'; // Your HomeScreen with BottomNavigationBar
import 'login_screen.dart';

// Global list to store notes. Each note is a Map with 'note' and 'date' keys.
List<Map<String, dynamic>> notesList = [];

void main() => runApp(ReflectDailyApp());

class ReflectDailyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReflectDaily',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        // Define other routes as needed
      },
    );
  }
}

class HomePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        final note = notesList[index];
        // Use DateFormat from the intl package to format dates
        final formattedDate =
            DateFormat('yyyy-MM-dd – kk:mm').format(note['date']);
        return ListTile(
          title: Text(note['note']),
          subtitle: Text(formattedDate),
        );
      },
    );
  }
}
