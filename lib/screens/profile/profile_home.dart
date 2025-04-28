import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/register_step.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/main_app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/services/route_service.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  ProfileHomeState createState() => ProfileHomeState();
}

class ProfileHomeState extends State<ProfileHomePage> with RouteAware {
  final PageController _pageController = PageController();
  User loginUser = User.defaultUser();
  List<StepData> stepList = [];

  @override
  void initState() {
    super.initState();
    getCardData();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
      getCardData();
    }
  }

  Future<void> getCardData() async {
    loginUser = await getLoginUser();

    if (loginUser.loanApplicationSubmitted) {
      getProfileSteps();
    } else {
      getRegisterSteps();
    }
  }

  Future<void> getProfileSteps() async {
    stepList = StepData.getProfileSteps();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getRegisterSteps() async {
    stepList = StepData.getRegisterSteps();

    int currentIndex = stepList
        .indexWhere((step) => step.loanFormState == loginUser.loanFormState);
    currentIndex = currentIndex < 0 ? 0 : currentIndex;
    for (int i = 0; i < stepList.length; i++) {
      if (i < currentIndex) {
        stepList[i].isFinish = true;
        stepList[i].isCurrent = false;
      } else if (i > currentIndex) {
        stepList[i].isFinish = false;
        stepList[i].isCurrent = false;
      } else {
        stepList[currentIndex].isFinish = false;
        stepList[currentIndex].isCurrent = true;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (loginUser.loanApplicationSubmitted)
                ? createProfileCard()
                : createRegisterSteps(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: ConstantData.PROFILE_INDEX,
        onItemTapped: (index) {
          setState(() {
            ConstantData.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }

  Widget createRegisterSteps() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: stepList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final item = stepList[index];

          return Opacity(
            opacity: item.isCurrent! || item.isFinish! ? 1.0 : 0.4,
            child: AbsorbPointer(
              absorbing: item.isFinish!,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    if (item.isCurrent! || item.isFinish!) {
                      RouteService.goToNavigator(context, item.page);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              size: 40,
                              color: CustomStyle.primary_color,
                            ),
                            CustomWidget.verticalSpacing(),
                            Text(
                              item.text,
                              textAlign: TextAlign.center,
                              style: CustomStyle.body(),
                            )
                          ],
                        ),
                      ),
                      if (!item.isCurrent!)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            item.isFinish! ? Icons.check_circle : Icons.lock,
                            size: 20,
                            color: item.isFinish! ? Colors.green : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget createProfileCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: stepList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final item = stepList[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: InkWell(
              onTap: () {
                RouteService.goToNavigator(context, item.page);
              },
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 40,
                          color: CustomStyle.primary_color,
                        ),
                        CustomWidget.verticalSpacing(),
                        Text(
                          item.text,
                          textAlign: TextAlign.center,
                          style: CustomStyle.body(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
