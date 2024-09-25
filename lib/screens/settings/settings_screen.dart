import 'package:flutter/material.dart';
import 'package:navigation/screens/sidebar/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Sidebar(
        onItemTap: (routeName) {
          Navigator.of(context).pop();
          if (routeName != '/settings') {
            Navigator.of(context).pushReplacementNamed(routeName);
          }
        },
        currentRoute: '/settings', // Add this line
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '',
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  userName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  userEmail,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildSettingCard(
                    icon: Icons.person,
                    title: 'Account Settings',
                    onTap: () {
                      // TODO: Navigate to account settings
                    },
                  ),
                  _buildSettingCard(
                    icon: Icons.email,
                    title: 'Email Settings',
                    onTap: () {
                      // TODO: Navigate to email settings
                    },
                  ),
                  _buildSettingCard(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {
                      // TODO: Navigate to notifications settings
                    },
                  ),
                  _buildSettingCard(
                    icon: Icons.security,
                    title: 'Privacy',
                    onTap: () {
                      // TODO: Navigate to privacy settings
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
