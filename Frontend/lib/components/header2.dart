import 'package:flutter/material.dart';
import 'package:crop/screens/menu.dart';

class Header extends StatelessWidget {
  final String title;
  final double progress;
  final VoidCallback onMenuPressed;
  final VoidCallback onProfilePressed;

  const Header({
    required this.title,
    this.progress = 0.0,
    required this.onMenuPressed,
    required this.onProfilePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 140,
            color: const Color(0xFF006838),
          ),
        ),
        Positioned(
          top: 20,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.menu),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              // Navigate to MenuPage when the menu icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPage()),
              );
            },
          ),
        ),
        Positioned(
          top: 20,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.account_circle),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: onProfilePressed,
          ),
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
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
              Container(
                height: 10,
                color: Colors.grey.shade400,
                width: MediaQuery.of(context).size.width,
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 10,
                  color: Colors.yellow.shade700,
                ),
              ),
              if (progress > 0.0 && progress < 1.0) ...[
                Positioned(
                  right: 0,
                  child: FractionallySizedBox(
                    widthFactor: 1.0 - progress,
                    child: Container(
                      height: 10,
                      color: const Color.fromARGB(255, 255, 255, 255),
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
