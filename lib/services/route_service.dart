import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/models/application.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/screens/loan/interview_appointment.dart';
import 'package:synpitarn/screens/loan/loan_type.dart';
import 'package:synpitarn/screens/loan/pending.dart';
import 'package:synpitarn/screens/profile/document_file.dart';
import 'package:synpitarn/screens/profile/information1.dart';
import 'package:synpitarn/screens/profile/information2.dart';
import 'package:synpitarn/screens/profile/work_permit.dart';

class RouteService {
  static late BuildContext _context;
  static late User _loginUser;

  static final Map<String, Widget> pageMap = {
    "null": WorkPermitPage(),
    "qr_scan": Information1Page(),
    "customer_information": DocumentFilePage(),
    "required_documents": Information2Page(),
    "additional_information": LoanTypePage(),
    "choose_loan_type": InterviewAppointmentPage(),
  };

  static Future<void> login(BuildContext context, User loginUser) async {
    _context = context;
    _loginUser = loginUser;

    await setLoginUser(loginUser);
    await setLoginStatus(true);

    checkLoginUserData(loginUser);
  }

  static Future<void> checkLoginUserData(User loginUser) async {
    await setLoginUser(loginUser);

    _loginUser = loginUser;

    if (_loginUser.loanApplicationSubmitted) {
      checkApplication();
    } else {
      Widget page = pageMap[_loginUser.loanFormState] ?? WorkPermitPage();
      goToNavigator(page);
    }
  }

  static Future<void> checkApplication() async {
    Application applicationResponse = await ApplicationRepository()
        .getApplication(_loginUser);

    if (applicationResponse.data.appointmentStatus ==
        APPOINTMENT_STATUS.pending.toString().split('.').last) {
      goToNavigator(PendingPage());
    } else {
      goToNavigator(HomePage());
    }
  }

  static void goToNavigator(Widget page) {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
