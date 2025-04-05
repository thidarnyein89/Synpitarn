import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/screens/auth/forget_password.dart';
import 'package:synpitarn/screens/auth/login.dart';
import 'package:synpitarn/screens/auth/otp.dart';

import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/auth/register.dart';
import 'package:synpitarn/screens/auth/set_password.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/screens/setting/guide.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});

  @override
  HomeNavigatorState createState() => HomeNavigatorState();
}

GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

class HomeNavigatorState extends State<HomeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;
        if (settings.name == "/") {
          // page = const HomePage();
          page = GuidePage();
        } else {
          page = Scaffold(
            body: Center(child: Text('Page not found: ${settings.name}')),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return page;
          },
        );
      },
    );
  }

  void resetToInitialRoute() {
    homeNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
          (Route<dynamic> route) => false,
    );
  }
}
