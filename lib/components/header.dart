import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final double progress;

  const Header({required this.title, this.progress = 0.0, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            color: const Color(0xFF006838),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Stack(
            children: [
              // Gray background for the progress bar
              Container(
                height: 10,
                color: Colors.grey.shade400,
                width: MediaQuery.of(context).size.width,
              ),
              // Yellow progress overlay
              FractionallySizedBox(
                widthFactor: progress, // Progress as a fraction of total width
                child: Container(
                  height: 10,
                  color: Colors.yellow.shade700,
                ),
              ),
              // Second overlay for partial yellow and gray
              if (progress > 0.0 && progress < 1.0) ...[
                Positioned(
                  right: 0,
                  child: FractionallySizedBox(
                    widthFactor: 1.0 - progress, // Remaining fraction for gray
                    child: Container(
                      height: 10,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
