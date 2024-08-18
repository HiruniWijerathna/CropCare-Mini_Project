import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/components/header.dart'; // Import the Header component
import 'package:crop/components/custom_button.dart'; // Import the CustomButton component

import 'set_new_password.dart'; // Import the screen to navigate to after OTP is verified

class EnterOtpPage extends StatelessWidget {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final FocusNode _focusNode = FocusNode();

  void _verifyOtp(BuildContext context) {
    // Implement OTP verification logic here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SetNewPasswordPage()),
    );
  }

  void _onOtpChanged(String value) {
    // Implement OTP changed logic here
    // For example, you could aggregate the value from all controllers and validate it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            // Header component
            Header(
              title: 'Verification OTP',
              progress: 0.66, // Adjust progress if needed
            ),

            Image.asset(
              'assets/fogot_password_2.png',
              width: 150,
              height: 250,
            ),

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
                        color: Color.fromARGB(255, 1, 51, 9).withOpacity(0.3),
                        spreadRadius: 4,
                        blurRadius: 0,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Fit content
                    children: [
                      Text(
                        'A 4 digit code has been sent to your registered mobile number',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => Container(
                            width: 60,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: index == 0 ? _focusNode : null,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 3) {
                                    FocusScope.of(context).nextFocus();
                                  } else {
                                    _focusNode.unfocus();
                                  }
                                }
                                _onOtpChanged(value);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Not received the code? ',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement resend OTP logic here
                        },
                        child: Text('Resend'),
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: 'Continue',
                        color: Color(0xFF006838), // Button color
                        onPressed: () => _verifyOtp(context),
                      ),
                      SizedBox(height: 10),
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
