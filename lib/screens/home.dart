import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/setting/about_us.dart';
import 'package:synpitarn/screens/setting/guide.dart';
import 'package:synpitarn/screens/setting/guide_header.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/models/aboutUs.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/data/app_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  final CommonService _commonService = CommonService();
  final PageController _pageController = PageController();

  final List<String> images = [
    'assets/images/slider1.jpeg',
    'assets/images/slider2.jpeg',
    'assets/images/slider3.jpeg',
  ];

  int _currentIndex = 0;

  List<AboutUS> aboutList = [];

  @override
  void initState() {
    super.initState();
    slideImage();
    readAboutUsData();
  }

  @override
  void dispose() {
    _pageController.dispose();
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

  Future<void> readAboutUsData() async {
    aboutList = await _commonService.readAboutUsData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
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
                        padding: CustomStyle.sliderPadding(),
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
            GuideHeaderPage(),
            createAboutUs(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: AppConfig.HOME_INDEX,
        onItemTapped: (index) {
          setState(() {
            AppConfig.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }

  Widget createAboutUs() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        double width = constraints.maxWidth;

        if (width >= 1200) {
          crossAxisCount = 6;
        } else if (width >= 900) {
          crossAxisCount = 5;
        } else if (width >= 600) {
          crossAxisCount = 4;
        }

        return Padding(
          padding: CustomStyle.pagePadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Get To Know Us", style: CustomStyle.subTitleBold()),
              CustomWidget.verticalSpacing(),
              GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                children:
                    aboutList
                        .asMap()
                        .map((index, aboutData) {
                          return MapEntry(index, gridItem(index));
                        })
                        .values
                        .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget gridItem(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutUsPage(activeIndex: index),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: CustomStyle.secondary_color,
            child: Icon(
              aboutList[index].icon,
              color: CustomStyle.icon_color,
            ),
          ),
          Expanded(
              child: Text(
                aboutList[index].titleEN,
                textAlign: TextAlign.center,
                style: CustomStyle.body(),
                softWrap: true,
                overflow: TextOverflow.visible,
                maxLines: 5,
              )
          ),
          CustomWidget.verticalSpacing(),
        ],
      ),
    );
  }
}
