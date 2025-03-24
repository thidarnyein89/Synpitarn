import 'package:flutter/material.dart';
import 'package:synpitarn/screens/auth/login.dart';

import 'my_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/synpitarn.jpg', height: 150), // Replace with your logo
              SizedBox(height: 20),
              Text(
                'Welcome from Synpitarn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyTheme.primary_color),
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Open Account screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.primary_color,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                  ),
                ),
                child: Text(
                  'Open Account for Loan Apply',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 30),
              Text('OR'),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.primary_color,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                  ),
                ),
                child: Text(
                  'Login To Your Account', // Fixed typo "You" to "Your"
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
