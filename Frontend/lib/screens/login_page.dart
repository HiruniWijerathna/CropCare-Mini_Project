import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/components/custom_input_field.dart'; // Import the CustomInputField component
import 'package:crop/screens/register_page.dart';
import 'package:crop/components/header.dart'; // Import the Header component
import 'package:crop/components/custom_button.dart'; // Import the CustomButton component
import 'package:crop/screens/enter_phone.dart';
import 'package:crop/screens/re_home.dart';

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
                      // Add the logo image here
                      Image.asset(
                        'assets/logo.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      CustomInputField(
                        labelText: 'Email',
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
                                color: Color(0xFF006838), // Dark green color
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Login',
                        color: const Color(0xFF006838), // Dark green color
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReHomePage()),
                          );
                          // Perform login action
                        },
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
                            color: Color(0xFF006838), // Dark green color
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

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
