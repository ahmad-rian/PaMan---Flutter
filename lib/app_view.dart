import 'package:flutter/material.dart';
import 'package:navigation/screens/login/welcome.dart';
import 'package:navigation/screens/home/views/home_screen.dart';
import 'package:navigation/screens/profile/profile_screen.dart';
import 'package:navigation/screens/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navigation/screens/login/login_page.dart';
import 'package:navigation/screens/login/register_page.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PAMAN',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade50,
          onBackground: Colors.black,
          primary: const Color(0xFF5C6BC0),
          secondary: const Color(0xFF26A69A),
          tertiary: const Color(0xFFFFB74D),
          outline: Colors.grey.shade400,
        ),
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return HomeScreen();
            } else {
              return Welcome();
            }
          }

          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
      routes: {
        '/welcome': (context) => Welcome(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
