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

class RouteRepository {
  static late BuildContext context;
  static late User loginUser;

  static Future<void> login(BuildContext para1, User para2) async {
    context = para1;
    loginUser = para2;

    await setLoginUser(loginUser);
    await setLoginStatus(true);

    final Map<String, Widget> pageMap = {
      "null": WorkPermitPage(),
      "qr_scan": Information1Page(),
      "customer_information": DocumentFilePage(),
      "required_documents": Information2Page(),
      "additional_information": LoanTypePage(),
      "choose_loan_type": InterviewAppointmentPage(),
    };

    if (loginUser.loanApplicationSubmitted) {
      checkApplication();
    } else {
      Widget page = pageMap[loginUser.loanFormState] ?? WorkPermitPage();
      goToNavigator(page);
    }
  }

  static Future<void> checkApplication() async {
    Application applicationResponse = await ApplicationRepository()
        .getApplication(loginUser);

    if (applicationResponse.data.appointmentStatus ==
        APPOINTMENT_STATUS.pending.toString().split('.').last) {
      goToNavigator(PendingPage());
    } else {
      goToNavigator(HomePage());
    }
  }

  static void goToNavigator(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
