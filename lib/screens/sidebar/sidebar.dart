import 'package:flutter/material.dart';
import 'package:navigation/screens/sidebar/sidebar_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onItemTap;
  final String currentRoute;

  const Sidebar({Key? key, required this.onItemTap, required this.currentRoute})
      : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? '';
      userEmail = prefs.getString('email') ?? '';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    widget.onItemTap('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            _buildUserHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  SidebarItem(
                    icon: FontAwesomeIcons.house,
                    title: 'Home',
                    onTap: () => widget.onItemTap('/home'),
                    isSelected: widget.currentRoute == '/home',
                  ),
                  SidebarItem(
                    icon: FontAwesomeIcons.user,
                    title: 'Profile',
                    onTap: () => widget.onItemTap('/profile'),
                    isSelected: widget.currentRoute == '/profile',
                  ),
                  SidebarItem(
                    icon: FontAwesomeIcons.gear,
                    title: 'Settings',
                    onTap: () => widget.onItemTap('/settings'),
                    isSelected: widget.currentRoute == '/settings',
                  ),
                ],
              ),
            ),
            Divider(color: Theme.of(context).dividerColor),
            SidebarItem(
              icon: FontAwesomeIcons.rightFromBracket,
              title: 'Logout',
              onTap: _logout,
              isLogout: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : '',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
