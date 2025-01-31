import 'package:crop/constants/env.dart';
import 'package:crop/screens/disease.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import dart:io for File class
import 'package:crop/components/custom_background.dart'; // Import the CustomBackground component
import 'package:crop/components/header2.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert';

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


  Future<void> _submit() async {
    if (_imageFile != null) {
      // Prepare to upload the image
      File file = File(_imageFile!.path);
      String url = "";
      if(widget.cropName=="Potato") {
        url = '/api/potato-predict';
      } else if(widget.cropName=="Tomato") {
        url = '/api/tomato-predict';
      } else if(widget.cropName=="Beans") {
        url = '/api/beans-predict';
      }

      // Create a multipart request
      var uri = Uri.parse(ENVConfig.serverUrl + url);
      var request = http.MultipartRequest('POST', uri);

      // Attach the file
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      try {
        // Send the request
        var response = await request.send();

        if (response.statusCode == 200) {
          // Handle success response
          var responseData = await http.Response.fromStream(response);
          var decodedData = jsonDecode(responseData.body) as Map<String, dynamic>; // Use dynamic

          print(decodedData);

          // Extract prediction and ensure it's a string
          var prediction = decodedData['predicted_label']?.toString() ?? 'Unknown';

          // Navigate to the DiseasePage with prediction results
          // Navigator.pushNamed(
          //   context,
          //   '/disease',
          //   arguments: {
          //     'imagePath': _imageFile!.path,
          //     'cropName': widget.cropName,
          //     'prediction': prediction,
          //   },
          // );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiseasePage(imagePath: _imageFile!.path, cropName: widget.cropName, diseaseName: prediction,)),
          );
        } else {
          // Handle error
          _showErrorDialog('Upload failed with status: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('Error occurred: $e');
      }
    } else {
      _showErrorDialog('Please take a photo or upload an image before submitting.');
    }
  }



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
