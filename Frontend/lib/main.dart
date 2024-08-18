import 'package:flutter/material.dart';
import 'screens/start.dart';
import 'screens/second.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/verify_otp.dart';
import 'screens/enter_phone.dart';
import 'screens/enter_otp.dart';
import 'screens/set_new_password.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/second': (context) => SecondPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/verify_otp': (context) => VerifyOtpPage(),
        '/enter_phone': (context) => EnterPhonePage(),
        '/enter_otp': (context) => EnterOtpPage(),
        '/set_new_password': (context) => SetNewPasswordPage(),
      },
    );
  }
}
