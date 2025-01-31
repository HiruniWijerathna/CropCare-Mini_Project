import 'package:flutter/material.dart';
import 'package:crop/components/header2.dart'; // Import the Header component
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/screens/menu.dart';
import 'package:crop/screens/profile.dart'; // Import the ProfilePage if needed

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: <Widget>[
            Header(
              title: 'Help & Support', // Set the title for the header
              onMenuPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              },
              onProfilePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Help & Support',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '1. How to use the app:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '   - Start by signing up or logging in to your account.\n'
                      '   - Navigate through the app using the bottom navigation bar.\n'
                      '   - Access different sections by tapping on the menu items.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '2. Frequently Asked Questions (FAQs):',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '   - How can I reset my password?\n'
                      '     - Go to the login page and tap on "Forgot Password" to reset it.\n'
                      '   - How do I contact support?\n'
                      '     - You can reach us via the "Contact Us" section in the settings.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '3. Contact Us:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '   - Email: support@example.com\n'
                      '   - Phone: +123 456 7890\n'
                      '   - Address: 123 Example Street, City, Country',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
