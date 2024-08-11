import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFC8DBD3), // Background color
      child: Stack(
        children: [
          // First rectangle
          Positioned(
            right: -50,
            bottom: -50,
            child: Transform.rotate(
              angle: 0.6, // Adjust the angle as needed
              child: Container(
                width: 200,
                height: 400,
                color: Color(0xFF006838),
              ),
            ),
          ),
          // Second rectangle
          Positioned(
            right: 30,
            bottom: 30,
            child: Transform.rotate(
              angle: 0.6, // Adjust the angle as needed
              child: Container(
                width: 200,
                height: 400,
                color: Color(0xFF4FA57D),
              ),
            ),
          ),
          // The child widget
          child,
        ],
      ),
    );
  }
}
