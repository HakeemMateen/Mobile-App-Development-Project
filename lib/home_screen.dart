import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'notes_service.dart';
import 'login_screen.dart'; // Import your LoginScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  DateTime _today = DateTime.now();
  bool _isLoggedIn = false; // Added login state

  List<Widget> _widgetOptions() => [
        _buildNotesListForToday(),
        Text('Gallery Placeholder'),
        CalendarScreen(),
        SettingsScreen(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        // Reload notes for today when the home button is pressed
        NotesService().loadNotesForDate(_today);
      }
    });
  }

  Widget _buildNotesListForToday() {
    List<String> notes = NotesService().savedNotes[_today] ?? [];
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: Colors.grey[300], // Set the banner color to grey
          child: Text(
            'How are we doing so far today, User?',
            style: TextStyle(fontSize: 16), // Adjust the font size as needed
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Note ${index + 1}'),
                subtitle: Text(notes[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to simulate user login
  void _login() {
    print('Login button pressed');
    setState(() {
      _isLoggedIn = true;
    });
    print('User is logged in: $_isLoggedIn');
  }

  @override
  Widget build(BuildContext context) {
    // Show login button if not logged in, else show the navigation bar and content
    return Scaffold(
      appBar: AppBar(
        title: Text('ReflectDaily'),
      ),
      body: _isLoggedIn
          ? Center(
              child: _widgetOptions()
                  .elementAt(_selectedIndex)) // Display the selected screen
          : Center(
              child: ElevatedButton(
                child: Text('Log In'),
                onPressed: _login, // Simulate a login
              ),
            ),
      bottomNavigationBar:
          _isLoggedIn // This will hide the BottomNavigationBar when logged out
              ? BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.photo),
                      label: 'Gallery',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Calendar',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  unselectedItemColor: Colors.grey[600],
                  backgroundColor: Colors.blueGrey[100],
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                )
              : null,
    );
  }
}
