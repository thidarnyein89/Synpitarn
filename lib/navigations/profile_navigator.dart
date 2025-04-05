import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/screens/auth/forget_password.dart';
import 'package:synpitarn/screens/auth/login.dart';
import 'package:synpitarn/screens/auth/otp.dart';

import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/auth/register.dart';
import 'package:synpitarn/screens/auth/set_password.dart';

class ProfileNavigator extends StatefulWidget {
  const ProfileNavigator({super.key});

  @override
  ProfileNavigatorState createState() => ProfileNavigatorState();
}

GlobalKey<NavigatorState> profileNavigatorKey = GlobalKey<NavigatorState>();

class ProfileNavigatorState extends State<ProfileNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: profileNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;
        if (settings.name == "/register") {
          page = const RegisterPage();
        } else if (settings.name == "/forgetPassword") {
          page = const ForgetPasswordPage();
        } else if (settings.name == "/otp") {
          page = OTPPage(loginUser: User.defaultUser());
        } else if (settings.name == "/setPassword") {
          page = SetPasswordPage(loginUser: User.defaultUser());
        } else {
          page = const LoginPage();
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
    profileNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
      (Route<dynamic> route) => false,
    );
  }
}
