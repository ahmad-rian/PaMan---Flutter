import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigation/screens/sidebar/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navigation/screens/add_password/add_password_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _updateGreeting();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'User';
    });
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Password Manager',
            style: TextStyle(color: Colors.black, fontSize: 20)),
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
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            _buildGreetingSection(),
            SizedBox(height: 20),
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildCategorySection(),
            SizedBox(height: 20),
            _buildRecentUsedSection(),
          ],
        ),
      ),
      floatingActionButton: _buildAddAccountButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(_greeting, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.notifications_none),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Password',
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCategoryButton(Icons.people, 'Social', Colors.blue[100]!),
            _buildCategoryButton(Icons.web, 'Browse', Colors.green[100]!),
            _buildCategoryButton(Icons.credit_card, 'Card', Colors.red[100]!),
            _buildCategoryButton(Icons.work, 'Work', Colors.orange[100]!),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentUsedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Used',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 10),
        _buildPasswordItem(
            'Google Account', 'alriansr@gmail.com', 'assets/icons/google.svg'),
        _buildPasswordItem('Netflix Personal', 'alriansr@gmail.com',
            'assets/icons/netflix.svg'),
        _buildPasswordItem(
            'Twitter', 'rian_syaifullah', 'assets/icons/twitter.svg'),
        _buildPasswordItem(
            'Instagram', 'rian_syaifullah', 'assets/icons/instagram.svg'),
        _buildPasswordItem(
            'Facebook', 'rian_syaifullah', 'assets/icons/facebook.svg'),
      ],
    );
  }

  Widget _buildPasswordItem(String title, String username, String iconPath) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: SvgPicture.asset(iconPath, width: 24, height: 24),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(username),
      trailing: IconButton(
        icon: Icon(Icons.copy, color: Colors.grey),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: username));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Username copied to clipboard')),
          );
        },
      ),
    );
  }

  Widget _buildAddAccountButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddPasswordScreen(),
        ));
      },
      icon: Icon(Icons.add, color: Colors.white),
      label: Text('Add Account', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.teal,
    );
  }
}
