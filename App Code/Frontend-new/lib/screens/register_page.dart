import 'dart:math';

import 'package:crop/constants/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To work with JSON responses
import 'package:crop/components/custom_input_field.dart';
import 'package:crop/components/header.dart';
import 'package:crop/components/custom_button.dart';
import 'package:crop/components/custom_background.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());

  double progress = 0.0;
  bool isFirstPartCompleted = false;
  bool isOtpPart = false;
  bool _isOtpValid = true;

  // Function to handle user registration
  Future<void> _registerUser() async {
    final url = Uri.parse(ENVConfig.serverUrl + '/api/create-user');
    final body = {
      "fullname": firstNameController.text,
      "lastname": lastNameController.text,
      "mobile": mobileNumberController.text,
      "email": emailController.text,
      "username": userNameController.text,
      "password": passwordController.text,
      "accepted":
          true, // Set to true since this indicates the user accepted terms
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Registration successful, navigate to login screen
        Navigator.pushNamed(context, '/login');
        _showSuccessDialog();
      } else {
        // Handle error
        _showErrorDialog('Registration failed. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error occurred. Please check your network connection.');
    }
  }

  // Progress update function
  void _updateProgress() {
    int filledFields = 0;
    if (firstNameController.text.isNotEmpty) filledFields++;
    if (lastNameController.text.isNotEmpty) filledFields++;
    if (userNameController.text.isNotEmpty) filledFields++;
    if (emailController.text.isNotEmpty) filledFields++;
    if (mobileNumberController.text.isNotEmpty) filledFields++;
    if (passwordController.text.isNotEmpty) filledFields++;

    setState(() {
      if (!isFirstPartCompleted) {
        progress = filledFields == 6 ? 0.5 : (filledFields / 12);
      } else if (!isOtpPart) {
        progress = 0.5;
      } else {
        progress = 1.0;
      }
    });
  }

  void _completeFirstPart() {
    setState(() {
      isFirstPartCompleted = true;
      progress = 0.5;
    });
  }

  void _showOtpPart() {
    setState(() {
      isOtpPart = true;
      progress = 1.0;
    });
  }

  String _generateOtp() {
    var random = Random();
    int otp = random.nextInt(9000) + 1000;
    return otp.toString();
  }

  void _onOtpChanged() {
    setState(() {
      _isOtpValid = true; // Reset OTP validity when user starts typing again
    });
  }

  Future<void> _sendOtp(phone) async {
    String mobile = phone.trim();
    if (mobile.isEmpty || mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    String otp = _generateOtp(); // Generate the OTP

    String apiUrl =
        'https://app.notify.lk/api/v1/send?user_id=29001&api_key=eVXfrsFREqEMGgK4uWvM&sender_id=NotifyDEMO&to=+94${mobile.substring(1)}&message=Confirm your mobile phone number by entering this $otp';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP message was sent.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_updateProgress);
    lastNameController.addListener(_updateProgress);
    userNameController.addListener(_updateProgress);
    emailController.addListener(_updateProgress);
    mobileNumberController.addListener(_updateProgress);
    passwordController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    firstNameController.removeListener(_updateProgress);
    lastNameController.removeListener(_updateProgress);
    userNameController.removeListener(_updateProgress);
    emailController.removeListener(_updateProgress);
    mobileNumberController.removeListener(_updateProgress);
    passwordController.removeListener(_updateProgress);

    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            Header(title: 'Register', progress: progress),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isFirstPartCompleted) ...[
                          CustomInputField(
                            labelText: 'First Name',
                            controller: firstNameController,
                          ),
                          CustomInputField(
                            labelText: 'Last Name',
                            controller: lastNameController,
                          ),
                          CustomInputField(
                            labelText: 'User Name',
                            controller: userNameController,
                          ),
                          CustomInputField(
                            labelText: 'Email',
                            controller: emailController,
                          ),
                          CustomInputField(
                            labelText: 'Mobile Number',
                            controller: mobileNumberController,
                          ),
                          CustomInputField(
                            labelText: 'Password',
                            controller: passwordController,
                            obscureText: true,
                          ),
                          CustomButton(
                            text: 'Continue',
                            color: Color(0xFF006838),
                            onPressed: () {
                              if (firstNameController.text.isNotEmpty &&
                                  lastNameController.text.isNotEmpty &&
                                  userNameController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  mobileNumberController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                _completeFirstPart();
                                _sendOtp(mobileNumberController.text);
                                _showOtpPart();
                              }
                              // _registerUser();
                            },
                          ),
                        ] else if (isOtpPart) ...[
                          const SizedBox(height: 40),
                          const Text(
                            'A 4 digit code has been sent to your registered mobile number',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              4,
                              (index) => Container(
                                width: 60,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: TextField(
                                  controller: _otpControllers[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  decoration: InputDecoration(
                                    counterText: "", // Hides the counter
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      if (index < 3) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                      _onOtpChanged();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Register',
                            color: Color(0xFF006838),
                            onPressed: () {
                              _registerUser(); // Call registration
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Registration successful!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login'); // Navigate to login
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
