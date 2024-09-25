import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigation/screens/sidebar/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navigation/screens/add_password/add_password_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String userName = '';
  late AnimationController _notificationController;
  late Animation<Offset> _notificationAnimation;
  String _notificationMessage = '';
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _initializeNotificationAnimation();
    _updateGreeting();
  }

  void _initializeNotificationAnimation() {
    _notificationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _notificationAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _notificationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _notificationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'User';
    });
  }

  void _updateGreeting() {
    final now = DateTime.now()
        .toUtc()
        .add(Duration(hours: 7)); // Convert to Asia/Jakarta timezone
    final hour = now.hour;

    setState(() {
      if (hour < 12) {
        _greeting = 'Good Morning';
      } else if (hour < 17) {
        _greeting = 'Good Afternoon';
      } else if (hour < 21) {
        _greeting = 'Good Evening';
      } else {
        _greeting = 'Good Night';
      }
    });
  }

  void _showNotification(String message) {
    setState(() {
      _notificationMessage = message;
    });
    _notificationController.forward(from: 0.0);
    Future.delayed(Duration(seconds: 2), () {
      _notificationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Password Manager', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Sidebar(
        onItemTap: (routeName) {
          Navigator.of(context).pop();
          if (routeName != '/home') {
            Navigator.of(context).pushReplacementNamed(routeName);
          }
        },
        currentRoute: '/home',
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello, $userName',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(_greeting, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      IconButton(
                          icon: Icon(Icons.notifications_none),
                          onPressed: () {}),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Password',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Category',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryButton(
                          Icons.people, 'Social', Colors.blue[100]!),
                      _buildCategoryButton(
                          Icons.web, 'Browse', Colors.green[100]!),
                      _buildCategoryButton(
                          Icons.credit_card, 'Card', Colors.red[100]!),
                      _buildCategoryButton(
                          Icons.work, 'Work', Colors.orange[100]!),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Recent Used',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildPasswordItem('Google Account',
                            'alriansr@gmail.com', Colors.blue),
                        _buildPasswordItem('Netflix Personal',
                            'alriansr@gmail.com', Colors.red),
                        _buildPasswordItem(
                            'Twitter', 'rian_syaifullah', Colors.lightBlue),
                        _buildPasswordItem(
                            'Instagram', 'rian_syaifullah', Colors.pink),
                        _buildPasswordItem(
                            'Facebook', 'rian_syaifullah', Colors.pink),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SlideTransition(
            position: _notificationAnimation,
            child: CustomNotification(message: _notificationMessage),
          ),
        ],
      ),
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPasswordScreen(),
            ));
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text('Add Account', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCategoryButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 30),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Widget _buildPasswordItem(String title, String username, Color color) {
    return ListTile(
      leading: _getAccountIcon(title),
      title: Text(title),
      subtitle: Text(username),
      trailing: IconButton(
        icon: Icon(Icons.copy),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: username));
          _showNotification('Username copied to clipboard');
        },
      ),
    );
  }

  Widget _getAccountIcon(String title) {
    switch (title.toLowerCase()) {
      case 'google account':
        return SvgPicture.asset('assets/icons/google.svg',
            width: 24, height: 24);
      case 'netflix personal':
        return SvgPicture.asset('assets/icons/netflix.svg',
            width: 24, height: 24);
      case 'twitter':
        return SvgPicture.asset('assets/icons/twitter.svg',
            width: 24, height: 24);
      case 'instagram':
        return SvgPicture.asset('assets/icons/instagram.svg',
            width: 24, height: 24);
      case 'facebook':
        return SvgPicture.asset('assets/icons/facebook.svg',
            width: 24, height: 24);
      default:
        return CircleAvatar(
          backgroundColor: _getColorForTitle(title),
          child: Text(title[0], style: TextStyle(color: Colors.white)),
        );
    }
  }

  Color _getColorForTitle(String title) {
    return Colors.primaries[title.hashCode % Colors.primaries.length];
  }
}

class CustomNotification extends StatelessWidget {
  final String message;

  const CustomNotification({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
