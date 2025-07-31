import 'package:flutter/material.dart';
import 'package:synpitarn/data/shared_rsa_value.dart';
import 'package:synpitarn/main.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/screens/loan/interview_appointment.dart';
import 'package:synpitarn/screens/profile/register/loan_type.dart';
import 'package:synpitarn/screens/profile/document_file.dart';
import 'package:synpitarn/screens/profile/register/customer_information.dart';
import 'package:synpitarn/screens/profile/register/additional_information.dart';
import 'package:synpitarn/screens/profile/register/work_permit.dart';
import 'package:synpitarn/services/notification_service.dart';

class RouteService {
  static late User _loginUser;

  static final Map<String, Widget> pageMap = {
    "null": WorkPermitPage(),
    "qr_scan": CustomerInformationPage(),
    "customer_information": DocumentFilePage(),
    "required_documents": Information2Page(),
    "additional_information": LoanTypePage(),
    "choose_loan_type": InterviewAppointmentPage(applicationData: null),
  };

  static Future<void> login(BuildContext context, User loginUser) async {
    _loginUser = loginUser;

    await setLoginUser(loginUser);
    await setLoginStatus(true);
    NotificationService.sendTokenIfAvailable();

    goToHome(context);
  }

  static Future<void> profile(BuildContext context) async {
    _loginUser = await getLoginUser();

    Widget page = pageMap[_loginUser.loanFormState] ?? WorkPermitPage();
    goToNavigator(context, page);
  }

  static void goToNavigator(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static void goToReplaceNavigator(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void goToMain(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
      (Route<dynamic> route) => false,
    );
  }

  static void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }
}
