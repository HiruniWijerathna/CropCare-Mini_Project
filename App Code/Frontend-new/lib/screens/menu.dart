import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String? username = "User name";
  String? email = "email@example.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "User name";
      email = prefs.getString('email') ?? "email@example.com";
    });
  }

  Future<void> _logout(BuildContext context) async {
    // Clear SharedPreferences data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data

    // Navigate to the login screen (or a provided route)
    Navigator.pushReplacementNamed(context, '/second'); // Change to your login route
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 0, 104, 52), // Dark Green Background Color
        child: Column(
          children: <Widget>[
            Container(
              color: const Color.fromARGB(255, 0, 104, 52), // Slightly Lighter Green
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  username ?? "User name",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                accountEmail: Text(
                  email ?? "email@example.com",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50.0,
                    color: Colors.black,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(3, 120, 85, 1), // Slightly Lighter Green
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildMenuItem(
                    context,
                    icon: Icons.home,
                    title: 'Home',
                    routeName: '/re_home',
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.person,
                    title: 'Profile',
                    routeName: '/profile',
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.language,
                    title: 'Select the Language',
                    routeName: '/select_lan',
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help,
                    title: 'Help',
                    routeName: '/help',
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    onTap: () => _logout(context), // Call the logout function
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
        required String title,
        required String routeName}) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovering = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovering = true),
          onExit: (_) => setState(() => isHovering = false),
          child: Container(
            color: isHovering
                ? Colors.greenAccent
                : const Color.fromARGB(
                255, 0, 104, 52), // Change background color on hover
            child: ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0), // Reduced padding for less sparseness
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, routeName);
              },
            ),
          ),
        );
      },
    );
  }
}
