import 'package:flutter/material.dart';
import 'screens/start.dart';
import 'screens/second.dart'; // Import the second screen
import 'screens/login_page.dart'; // Import the login screen
import 'screens/register_page.dart'; // Import the register screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CropCare',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Inter', // Set the default font family
      ),
      home: Start(),
      routes: {
        '/second': (context) => Second(), // Define the route for the second screen
        '/login': (context) => LoginPage(), // Define the route for the login screen
        '/register': (context) => RegisterPage(), // Define the route for the register screen
      },
    );
  }
}
