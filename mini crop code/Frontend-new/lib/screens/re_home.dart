import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart';
import 'package:crop/components/header2.dart'; // Import the Header component

class ReHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title: 'Home',
                progress: 0.0, // You can set this to whatever value you need
                onMenuPressed: () {
                  // Handle menu button press
                },
                onProfilePressed: () {
                  // Handle profile button press
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 58, 161, 113),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Hi,\nWelcome!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(
                            255, 0, 37, 20), // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Disease Identification',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 37, 20),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Crop Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CropCategoryItem(
                imagePath: 'assets/potato.jpg',
                cropName: 'Potato',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/uplode_photo',
                    arguments: {
                      'imagePath': 'assets/potato.jpg',
                      'cropName': 'Potato',
                    },
                  );
                },
              ),
              CropCategoryItem(
                imagePath: 'assets/beans.jpg',
                cropName: 'Beans',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/uplode_photo',
                    arguments: {
                      'imagePath': 'assets/beans.jpg',
                      'cropName': 'Beans',
                    },
                  );
                },
              ),
              CropCategoryItem(
                imagePath: 'assets/tomato.jpg',
                cropName: 'Tomato',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/uplode_photo',
                    arguments: {
                      'imagePath': 'assets/tomato.jpg',
                      'cropName': 'Tomato',
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CropCategoryItem extends StatelessWidget {
  final String imagePath;
  final String cropName;
  final VoidCallback onTap;

  const CropCategoryItem({
    required this.imagePath,
    required this.cropName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 104, 65),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  cropName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
