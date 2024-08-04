import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart';

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Logo image in your assets folder
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/new.png', // The image for the second page
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 20),
                Text(
                  'Simply upload a photo\nand let CropCare handle the rest',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF006838),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 154,
                      height: 53,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login'); // Navigate to login screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF006838), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 154,
                      height: 53,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register'); // Navigate to register screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: Color(0xFF006838), // Border color
                            ),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0xFF006838),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
