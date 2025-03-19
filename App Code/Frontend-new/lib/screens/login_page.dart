import 'package:crop/constants/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crop/components/custom_background.dart';
import 'package:crop/components/custom_input_field.dart';
import 'package:crop/components/header.dart';
import 'package:crop/components/custom_button.dart';
import 'package:crop/screens/re_home.dart';
import 'package:crop/screens/register_page.dart';
import 'package:crop/screens/enter_phone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<double> _progressNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateProgress);
    _passwordController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateProgress);
    _passwordController.removeListener(_updateProgress);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    double progress = 0.0;
    if (_emailController.text.isNotEmpty) {
      progress += 0.5;
    }
    if (_passwordController.text.isNotEmpty) {
      progress += 0.5;
    }
    _progressNotifier.value = progress;
  }

  Future<void> _login() async {
    const String apiUrl = ENVConfig.serverUrl+'/api/login'; // Replace with your API URL
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'username': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', responseData['user']['username'] ?? 'No User');
        prefs.setString('email', responseData['user']['email'] ?? 'No Email');
        prefs.setString('userid', responseData['user']['user_id'] ?? 'No ID');
        prefs.setString('fullname', responseData['user']['fullname'] ?? 'Full Name');
        prefs.setString('avatar', responseData['user']['avatar'] ?? 'https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png');
        prefs.setString('mobile', responseData['user']['mobile'] ?? '011223232');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReHomePage()),
        );
      } else {
        // Show error message
        final errorData = json.decode(response.body);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(errorData['error']),
          ),
        );
      }
    } catch (e) {
      // Show network error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("An error occurred: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            ValueListenableBuilder<double>(
              valueListenable: _progressNotifier,
              builder: (context, progress, child) {
                return Header(title: 'Login', progress: progress);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/logo.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      CustomInputField(
                        labelText: 'Username',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomInputField(
                        labelText: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (value) {}),
                              const Text('Remember me'),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnterPhonePage()),
                              );
                            },
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                color: Color(0xFF006838),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Login',
                        color: const Color(0xFF006838),
                        onPressed: _login, // Call the login function
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: const Text(
                          'You haven\'t account? you can Register',
                          style: TextStyle(
                            color: Color(0xFF006838),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

