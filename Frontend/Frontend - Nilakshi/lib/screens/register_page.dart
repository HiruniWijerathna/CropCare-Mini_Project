import 'package:flutter/material.dart';
import 'package:crop/components/custom_input_field.dart'; // Import the CustomInputField component
import 'package:crop/components/header.dart'; // Import the Header component
import 'package:crop/components/custom_button.dart'; // Import the CustomButton component
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component

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
  final TextEditingController otpController = TextEditingController(); // Controller for OTP

  double progress = 0.0;
  bool isFirstPartCompleted = false;
  bool isOtpPart = false;

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
        // Progress for the first part (half filled)
        progress = filledFields == 6 ? 0.5 : (filledFields / 12);
      } else if (!isOtpPart) {
        // Keep it at half until OTP part is shown
        progress = 0.5;
      } else {
        // Full progress when OTP screen is active
        progress = 1.0;
      }
    });
  }

  void _completeFirstPart() {
    setState(() {
      isFirstPartCompleted = true;
      progress = 0.5; // Set progress to half when the first part is completed
    });
  }

  void _showOtpPart() {
    setState(() {
      isOtpPart = true;
      progress = 1.0; // Set progress to full when OTP screen is shown
    });
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to update progress when input fields change
    firstNameController.addListener(_updateProgress);
    lastNameController.addListener(_updateProgress);
    userNameController.addListener(_updateProgress);
    emailController.addListener(_updateProgress);
    mobileNumberController.addListener(_updateProgress);
    passwordController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    // Remove listeners when the widget is disposed
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
            Header(title: 'Register', progress: progress), // Add the header with progress
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
                            color: Color(0xFF006838), // Dark green color
                            onPressed: () {
                              if (firstNameController.text.isNotEmpty &&
                                  lastNameController.text.isNotEmpty &&
                                  userNameController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  mobileNumberController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                _completeFirstPart();
                                _showOtpPart();
                              }
                            },
                          ),
                        ] else if (isOtpPart) ...[
                          const SizedBox(height: 40),
                          const Text(
                            'A 4 digit code has been sent to your registered mobile number',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: otpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 24),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Not received the code?'),
                              GestureDetector(
                                onTap: () {
                                  // Handle resend OTP logic
                                },
                                child: const Text(
                                  'Resend',
                                  style: TextStyle(
                                    color: Color(0xFF006838), // Dark green color
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Continue',
                            color: Color(0xFF006838), // Dark green color
                            onPressed: () {
                              // Handle OTP verification logic
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
}
