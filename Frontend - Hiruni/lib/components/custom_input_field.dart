import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;

  CustomInputField({
    required this.labelText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFF006838)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF006838), width: 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF006838), width: 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          fillColor: Color.fromARGB(
              255, 255, 255, 255), // Set the inside color to white
          filled: true, // Required to make the fill color visible
        ),
      ),
    );
  }
}
