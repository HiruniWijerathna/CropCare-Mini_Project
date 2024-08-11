import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/components/custom_input_field.dart'; // Import the CustomInputField component
import 'package:crop/components/custom_button.dart'; // Import the CustomButton component
import 'package:crop/components/header.dart'; // Import the Header component

class SetNewPasswordScreen extends StatelessWidget {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _changePassword(BuildContext context) {
    // Implement password change logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password has been successfully changed')),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header component
            Header(
              title: 'Set New Password',
              progress: 1.0, // Adjust progress if needed
            ),

            SizedBox(height: 20), // Space between header and image

            Center(
              child: Image.asset(
                'assets/fogot_password_3.png',
                width: 150,
                height: 250,
              ),
            ),

            SizedBox(height: 20), // Space between image and content

            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(18),
                  padding: const EdgeInsets.all(16.0), // Box padding
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the box
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 48, 17).withOpacity(0.3),
                        spreadRadius: 4,
                        blurRadius: 0,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Fit content
                    children: [
                      // New Password Input Field
                      CustomInputField(
                        labelText: 'New Password',
                        controller: _newPasswordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      // Confirm Password Input Field
                      CustomInputField(
                        labelText: 'Confirm Password',
                        controller: _confirmPasswordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      // Save Button
                      CustomButton(
                        text: 'Save',
                        color: Color(0xFF006838), // Button color
                        textColor: Colors.white, // Text color
                        onPressed: () => _changePassword(context),
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
