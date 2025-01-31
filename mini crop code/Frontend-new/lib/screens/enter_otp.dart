import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/components/header.dart'; // Import the Header component
import 'package:crop/components/custom_button.dart'; // Import the CustomButton component
import 'set_new_password.dart'; // Import the screen to navigate to after OTP is verified
import 'dart:async';

class EnterOtpPage extends StatefulWidget {
  final String initialOtp;
  final String mobile;

  EnterOtpPage({required this.initialOtp, required this.mobile}); // Constructor to receive OTP

  @override
  _EnterOtpPageState createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  bool _isOtpValid = true;
  bool _isResendingOtp = false;
  Timer? _resendTimer;
  int _resendTimerCountdown = 30;

  void _verifyOtp(BuildContext context) {
    String enteredOtp = _otpControllers.map((controller) => controller.text).join();

    if (enteredOtp.length == 4 && enteredOtp == widget.initialOtp) {
      // OTP is valid, proceed to next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetNewPasswordPage(mobile: widget.mobile,)),
      );
    } else {
      setState(() {
        _isOtpValid = false; // Show error message if OTP is invalid
      });
    }
  }

  void _onOtpChanged() {
    setState(() {
      _isOtpValid = true; // Reset OTP validity when user starts typing again
    });
  }

  void _resendOtp() {
    setState(() {
      _isResendingOtp = true;
      _resendTimerCountdown = 30;
    });

    // Simulate OTP sending
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isResendingOtp = false;
      });

      // Set a new OTP for the sake of simulation
      // widget.initialOtp = "1234"; // New OTP set after resending (in real case, fetch new OTP from API)
    });

    _startResendTimer();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimerCountdown > 0) {
        setState(() {
          _resendTimerCountdown--;
        });
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpControllers.forEach((controller) => controller.dispose());
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: SingleChildScrollView(
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

                Center(
                  child: Container(
                    margin: EdgeInsets.all(18),
                    padding: const EdgeInsets.all(16.0), // Box padding
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the box
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
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
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: InputDecoration(
                                  counterText: "", // Hides the counter
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 15),
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
                        if (!_isOtpValid)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Invalid OTP. Please try again.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(height: 20),
                        Text(
                          'Not received the code? ',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        _isResendingOtp
                            ? CircularProgressIndicator() // Show loading indicator while resending
                            : _resendTimerCountdown > 0
                            ? Text('Resend available in $_resendTimerCountdown seconds')
                            : TextButton(
                          onPressed: _resendOtp,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
