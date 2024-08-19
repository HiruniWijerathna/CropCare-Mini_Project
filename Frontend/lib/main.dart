import 'package:flutter/material.dart';
import 'screens/start.dart';
import 'screens/second.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/verify_otp.dart';
import 'screens/enter_phone.dart';
import 'screens/enter_otp.dart';
import 'screens/set_new_password.dart';
import 'screens/re_home.dart';
import 'screens/uplode_photo.dart';
import 'screens/disease.dart';
import 'screens/menu.dart';
import 'screens/profile.dart';
import 'screens/select_lan.dart';
import 'screens/help.dart';

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
        '/re_home': (context) => ReHomePage(),
        '/menu': (context) => MenuPage(),
        '/profile': (context) => ProfilePage(),
        '/select_lan': (context) => SelectLanguagePage(),
        '/help': (context) => HelpPage(),

        // Note: Updated this route to handle arguments
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/uplode_photo') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return UplodePhotoPage(
                imagePath: args['imagePath']!,
                cropName: args['cropName']!,
              );
            },
          );
        }
        if (settings.name == '/disease') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return DiseasePage(
                imagePath: args['imagePath']!,
                cropName: args['cropName']!,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
