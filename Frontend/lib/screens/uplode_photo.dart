import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import dart:io for File class
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/components/header2.dart'; // Import the Header component

class UplodePhotoPage extends StatefulWidget {
  final String imagePath;
  final String cropName;

  const UplodePhotoPage({
    Key? key,
    required this.imagePath,
    required this.cropName,
  }) : super(key: key);

  @override
  _UplodePhotoPageState createState() => _UplodePhotoPageState();
}

class _UplodePhotoPageState extends State<UplodePhotoPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
      }
    });
  }

  Future<void> _uploadFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
      }
    });
  }

  void _submit() {
    if (_imageFile != null) {
      // Navigate to the DiseasePage
      Navigator.pushNamed(
        context,
        '/disease',
        arguments: {
          'imagePath': _imageFile!.path,
          'cropName': widget.cropName,
        },
      );
    } else {
      // Show an alert if no image is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Image Selected'),
            content: Text(
                'Please take a photo or upload an image before submitting.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            Header(
              title: 'Disease Identification',
              progress: 0.7,
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
                  height: 470,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 160, 107).withOpacity(0.5),
                    border: Border.all(
                      color: Colors.green.shade700,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.only(
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
                        height: 280, // Adjust height as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(1),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _imageFile != null
                                  ? Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      widget.imagePath,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.cropName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 99, 3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _takePhoto,
                        child: const Text('Take a photo'),
                        style: ElevatedButton.styleFrom(),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _uploadFromGallery,
                        child: const Text('Upload from Gallery'),
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Submit'),
                        style: ElevatedButton.styleFrom(),
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
