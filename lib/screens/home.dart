import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synpitarn/screens/setting/guide.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  final PageController _pageController = PageController();

  final List<String> images = [
    'assets/images/slider1.jpeg',
    'assets/images/slider2.jpeg',
    'assets/images/slider3.jpeg',
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    slideImage();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Properly dispose the PageController
    super.dispose();
  }

  void slideImage() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentIndex < images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      if (mounted) {
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox( // Replaces Expanded with SizedBox
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            images[index],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GuidePage()
          ],
        ),
      ),
    );
  }

}