import 'package:flutter/material.dart';
import 'screens/enter_phone.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forgot Password',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: EnterPhoneScreen(),
    );
  }
}
