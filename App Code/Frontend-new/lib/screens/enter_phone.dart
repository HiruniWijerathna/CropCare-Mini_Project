import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/components/custom_input_field.dart'; // Import the CustomInputField component
import 'package:crop/components/header.dart'; // Import the Header component
import 'package:crop/components/custom_button.dart'; // Import the CustomButton component
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:math'; // For generating random OTP

import 'enter_otp.dart'; // Import the screen to navigate to after OTP is sent

class EnterPhonePage extends StatelessWidget {
  final _phoneController = TextEditingController();

  // Function to generate a 4-digit OTP
  String _generateOtp() {
    var random = Random();
    int otp = random.nextInt(9000) + 1000; // Ensures a 4-digit OTP
    return otp.toString();
  }

  // Function to send OTP
  Future<void> _sendOtp(BuildContext context) async {
    String mobile = _phoneController.text.trim();
    if (mobile.isEmpty || mobile.length != 10) {
      // Validate phone number
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    String otp = _generateOtp(); // Generate the OTP

    String apiUrl =
        'https://app.notify.lk/api/v1/send?user_id=29001&api_key=eVXfrsFREqEMGgK4uWvM&sender_id=NotifyDEMO&to=+94${mobile.substring(1)}&message=Your OTP code is $otp';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Navigate to the EnterOtpPage and pass the OTP
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterOtpPage(initialOtp: otp, mobile: mobile),
          ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header component
              Header(
                title: 'Forgot Password',
                progress: 0.33, // Adjust progress if needed
              ),

              Image.asset(
                'assets/fogot_password_1.png',
                width: 150,
                height: 250,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: const EdgeInsets.all(26.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the box
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 56, 28).withOpacity(0.3),
                        spreadRadius: 4,
                        blurRadius: 0,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // To make the box size fit its content
                    children: [
                      Text(
                        'Please Enter Your Phone Number To Receive a Verification Code',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      CustomInputField(
                        labelText: 'Mobile Number',
                        controller: _phoneController,
                        obscureText:
                            false, // Set to true if you want to hide input text
                      ),
                      SizedBox(height: 25),
                      CustomButton(
                        text: 'Continue',
                        color:
                            Color(0xFF006838), // Use the desired button color
                        onPressed: () => _sendOtp(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
