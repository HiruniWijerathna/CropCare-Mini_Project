import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:crop/components/custom_background.dart';
import 'package:crop/components/custom_input_field.dart';
import 'package:crop/components/header2.dart';
import 'package:crop/components/custom_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set initial values for controllers if needed

    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: <Widget>[
            Header(
              title: 'Edit Profile',
              onMenuPressed: () {
                // Handle menu press
              },
              onProfilePressed: () {
                // Handle profile press
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : AssetImage('assets/profile_image.png')
                                    as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                icon:
                                    Icon(Icons.camera_alt, color: Colors.black),
                                onPressed: () {
                                  _showPicker(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomInputField(
                      labelText: 'Full Name',
                      controller: fullNameController,
                    ),
                    CustomInputField(
                      labelText: 'Mobile Number',
                      controller: mobileNumberController,
                    ),
                    CustomInputField(
                      labelText: 'Email',
                      controller: emailController,
                    ),
                    CustomInputField(
                      labelText: 'User Name',
                      controller: userNameController,
                    ),
                    SizedBox(height: 30),
                    CustomButton(
                      text: 'Save',
                      color: Color(0xFF006838),
                      onPressed: () {
                        // Handle save profile details
                      },
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
