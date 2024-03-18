import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Theme"),
            subtitle: Text("Dark/Light theme toggle"),
            onTap: () {
              // Implement theme toggle functionality here
            },
          ),
          ListTile(
            title: Text("Manage Data"),
            onTap: () {
              // Implement data management functionality here
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              // Navigate back to the LoginScreen
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/', // Assuming '/' is your LoginScreen route
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
