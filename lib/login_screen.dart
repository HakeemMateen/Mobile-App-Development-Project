import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Login'),
          onPressed: () {
            // Replace with your login logic, then navigate to HomeScreen
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
      ),
    );
  }
}
