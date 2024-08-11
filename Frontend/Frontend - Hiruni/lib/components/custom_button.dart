import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color; // Background color
  final Color textColor; // Text color
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.textColor = Colors.white, // Default text color is white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Button background color
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: textColor, // Set text color here
        ),
      ),
    );
  }
}
