import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/components/header2.dart'; // Import the Header2 component
import 'dart:io'; // Import dart:io for the File class

class DiseasePage extends StatelessWidget {
  final String imagePath;
  final String cropName;
  final String? diseaseName;
  final double? diseaseSeverity; // value between 0.0 and 1.0

  const DiseasePage({
    Key? key,
    required this.imagePath,
    required this.cropName,
    this.diseaseName,
    this.diseaseSeverity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            Header(
              title: 'Disease Identification',
              progress: 1.0, // Example value, adjust as needed
              onMenuPressed: () {
                // Handle menu button press
              },
              onProfilePressed: () {
                // Handle profile button press
              },
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 350,
                  height: 520, // Adjusted height to accommodate new elements
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 160, 107).withOpacity(0.5),
                    border: Border.all(
                      color: Colors.green.shade700,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(1),
                        ),
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cropName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 99, 3),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (diseaseName != null)
                              Text(
                                diseaseName!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (diseaseSeverity != null)
                        LinearProgressIndicator(
                          value: diseaseSeverity,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.red,
                          minHeight: 10,
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Navigate back to the previous page
                        },
                        child: const Text('Try Another'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
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
