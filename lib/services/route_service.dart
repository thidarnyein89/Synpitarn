import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/main.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/models/application_response.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/screens/loan/interview_appointment.dart';
import 'package:synpitarn/screens/profile/loan_type.dart';
import 'package:synpitarn/screens/loan/pending.dart';
import 'package:synpitarn/screens/profile/document_file.dart';
import 'package:synpitarn/screens/profile/information1.dart';
import 'package:synpitarn/screens/profile/information2.dart';
import 'package:synpitarn/screens/profile/profile_home.dart';
import 'package:synpitarn/screens/profile/work_permit.dart';
import 'package:synpitarn/services/common_service.dart';

class RouteService {
  static late User _loginUser;

  static final Map<String, Widget> pageMap = {
    "null": WorkPermitPage(),
    "qr_scan": Information1Page(),
    "customer_information": DocumentFilePage(),
    "required_documents": Information2Page(),
    "additional_information": LoanTypePage(),
    "choose_loan_type": InterviewAppointmentPage(
      applicationData: null,
    ),
  };

  static Future<void> login(BuildContext context, User loginUser) async {
    _loginUser = loginUser;

    await setLoginUser(loginUser);
    await setLoginStatus(true);

    goToHome(context);
  }

  static Future<void> profile(BuildContext context) async {
    _loginUser = await getLoginUser();

    Widget page = pageMap[_loginUser.loanFormState] ?? WorkPermitPage();
    goToNavigator(context, page);
  }

  static void goToNavigator(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
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
