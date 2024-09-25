import 'package:flutter/material.dart';

class AddPasswordScreen extends StatefulWidget {
  @override
  _AddPasswordScreenState createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Password'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a website or app',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight
                        .w400, // Mengatur ketebalan teks agar lebih ringan
                    color: Colors
                        .grey[600], // Mengatur warna teks agar lebih halus
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color:
                        Colors.grey[600], // Menyesuaikan warna ikon dengan teks
                  ),
                  filled: true,
                  fillColor: Colors
                      .grey[200], // Warna latar belakang yang lebih lembut
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none, // Menghapus garis tepi
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20), // Memberi ruang di dalam TextField
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChip(
                    label: Text('+ Add'),
                    onPressed: () {
                      // Add custom site/app logic
                    },
                  ),
                  FilterChip(
                    label: Text('Twitter'),
                    selected: true,
                    onSelected: (bool selected) {},
                    backgroundColor: Colors.blue,
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  FilterChip(
                    label: Text('Instagram'),
                    onSelected: (bool selected) {},
                  ),
                  FilterChip(
                    label: Text('Facebook'),
                    onSelected: (bool selected) {},
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('www.twitter.com',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Save password logic
                  Navigator.pop(context); // Return to previous screen
                },
                child: Text('OKE DONE'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // Match the FAB color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
