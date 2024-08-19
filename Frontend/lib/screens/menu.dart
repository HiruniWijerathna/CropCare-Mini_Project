import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 0, 104, 52), // Dark Green Background Color
        child: Column(
          children: <Widget>[
            Container(
              color: Color.fromARGB(255, 0, 104, 52), // Slightly Lighter Green
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  "User name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                accountEmail: null,
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50.0,
                    color: Colors.black,
                  ),
                ),
                decoration: BoxDecoration(
                  color:
                      Color.fromRGBO(3, 120, 85, 1), // Slightly Lighter Green
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
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    routeName: '/second',
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
                : Color.fromARGB(
                    255, 0, 104, 52), // Change background color on hover
            child: ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
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
