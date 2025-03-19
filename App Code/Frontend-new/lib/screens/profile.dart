import 'package:crop/constants/env.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crop/components/custom_background.dart';
import 'package:crop/components/custom_input_field.dart';
import 'package:crop/components/header2.dart';
import 'package:crop/components/custom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Method to load user data from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userNameController.text = prefs.getString('username') ?? "User name";
      emailController.text = prefs.getString('email') ?? "email@example.com";
      fullNameController.text = prefs.getString('fullname') ?? "Full Name";
      mobileNumberController.text = prefs.getString('mobile') ?? "0123456789";
      _avatarUrl = prefs.getString('avatar') ??
          "https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png";
    });
  }

  // Method to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to show picker dialog
  void _showPicker(BuildContext context) {
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
                },
              ),
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

  Future<String> _uploadImage(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/dkox7lwxe/image/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    request.fields['upload_preset'] = 'gtnnidje'; // Your Cloudinary upload preset

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final cloudinaryData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return cloudinaryData['secure_url'];
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method to update user data (PUT request)
  Future<void> _updateUserProfile() async {
    String apiUrl = ENVConfig.serverUrl + '/api/update-profile';

    try {
      String? avatarUrl;

      // If an image is selected, upload it and get the URL
      if (_image != null) {
        avatarUrl = await _uploadImage(_image!); // Implement _uploadImage to upload image to the server and return the URL
      } else {
        avatarUrl = _avatarUrl; // Use the existing avatar URL if no image is selected
      }

      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": userNameController.text,
          "fullname": fullNameController.text,
          "email": emailController.text,
          "mobile": mobileNumberController.text,
          "avatar": avatarUrl,
        }),
      );

      if (response.statusCode == 200) {
        // Update successful
        print('Profile updated successfully!');

        // Parse the response to get updated user data
        final responseData = jsonDecode(response.body);

        // Update SharedPreferences with the new user data
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', userNameController.text);
        await prefs.setString('email', emailController.text);
        await prefs.setString('fullname', fullNameController.text,);
        await prefs.setString('avatar', avatarUrl ?? 'https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png');
        await prefs.setString('mobile', mobileNumberController.text);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Future<String> _uploadImage(File imageFile) async {
  //   String uploadUrl = ENVConfig.serverUrl + '/api/upload-avatar';
  //
  //   var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
  //   request.files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));
  //
  //   var res = await request.send();
  //   if (res.statusCode == 200) {
  //     // Assuming the server returns the image URL in the response
  //     var resString = await res.stream.bytesToString();
  //     var resJson = jsonDecode(resString);
  //     return resJson['avatar_url'];  // Adjust according to your backend's response
  //   } else {
  //     throw Exception('Failed to upload avatar');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
                                : NetworkImage(_avatarUrl!) as ImageProvider,
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
                        _updateUserProfile();
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
