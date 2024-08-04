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
            right: -80,
            bottom: -30,
            child: Transform.rotate(
              angle: 0.6, // Adjust the angle as needed
              child: Container(
                width: 200,
                height: 300,
                color: Color(0xFF006838),
              ),
            ),
          ),
          // Second rectangle
          Positioned(
            right: -180,
            bottom: 30,
            child: Transform.rotate(
              angle: 0.6, // Adjust the angle as needed
              child: Container(
                width: 200,
                height: 800,
                color: Color.fromARGB(255, 122, 200, 163),
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
