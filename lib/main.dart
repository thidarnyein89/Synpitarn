import 'package:flutter/material.dart';
import 'package:synpitarn/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const Banner(
        message: 'Synpitarn',
        location: BannerLocation.bottomStart,
        child: HomePage(),
      ),
    );
  }
}