import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/components/custom_input_field.dart'; // Import the CustomInputField component
import 'package:crop/components/header.dart'; // Import the Header component
import 'package:crop/components/custom_button.dart'; // Import the CustomButton component

import 'enter_otp.dart'; // Import the screen to navigate to after OTP is sent

class EnterPhonePage extends StatelessWidget {
  final _phoneController = TextEditingController();

  void _sendOtp(BuildContext context) {
    // Implement sending OTP logic here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EnterOtpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
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

            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(18),
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
            ),
          ],
        ),
      ),
    );
  }
}
