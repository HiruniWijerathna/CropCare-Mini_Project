import 'package:flutter/material.dart';
import 'package:crop/components/custom_background.dart'; // Import your custom background
import 'package:crop/components/header2.dart'; // Import your custom header
import 'package:crop/components/custom_button.dart'; // Import your custom button

class SelectLanguagePage extends StatefulWidget {
  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  String _selectedLanguage = 'English';

  final List<String> _languages = [
    'Arabic',
    'Japanese', // Updated to match the language list
    'English',
    'French',
    'Hindi',
    'Russian',
    'Sinhala',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: <Widget>[
            Header(
              title: 'Select Language',
              onMenuPressed: () {
                // Handle menu press
              },
              onProfilePressed: () {
                // Handle profile press
              },
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  // Display the selected language with an icon
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF006838),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.language,
                          color: Color(0xFF006838),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedLanguage,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // List of languages with radio buttons
                  for (var language in _languages)
                    ListTile(
                      title: Text(language),
                      leading: Radio<String>(
                        value: language,
                        groupValue: _selectedLanguage,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                        },
                      ),
                    ),
                  SizedBox(height: 20),
                  // Save button
                  CustomButton(
                    text: 'Save',
                    color: Color(0xFF006838),
                    onPressed: () {
                      // Handle language selection and save the selected language
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Selected Language: $_selectedLanguage'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
