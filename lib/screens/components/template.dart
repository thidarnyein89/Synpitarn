import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/navigations/home_navigator.dart';
import 'package:synpitarn/navigations/profile_navigator.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  TemplateState createState() => TemplateState();
}

class TemplateState extends State<TemplatePage> {
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    homeNavigatorKey,
    profileNavigatorKey,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _systemBackButtonPressed() async {

    final navigator = _navigatorKeys[AppConfig.CURRENT_INDEX].currentState;

    if (navigator?.canPop() == true) {
      navigator?.pop();
      return false;
    } else if (AppConfig.CURRENT_INDEX == 1) {
      setState(() {
        AppConfig.CURRENT_INDEX = 0;
      });
      return false;
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        bool value = await _systemBackButtonPressed();
        if (value) {
          navigator.pop(result);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: AppConfig.CURRENT_INDEX,
            children: const <Widget>[HomeNavigator(), ProfileNavigator()],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: AppConfig.CURRENT_INDEX,
          onItemTapped: (index) {
            setState(() {
              AppConfig.CURRENT_INDEX = index;
            });
          },
        ),
      ),
    );
  }
}
