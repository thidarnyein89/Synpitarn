import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterStep {
  IconData icon = Icons.qr_code_scanner_outlined;
  String text = "";
  bool canEntry = false;
  bool canSkip = false;

  RegisterStep({
    required this.icon,
    required this.text,
    required this.canEntry,
    required this.canSkip,
  });

  static List<RegisterStep> getCustomTab() {
    List<RegisterStep> stepList = [];

    stepList.add(RegisterStep(
      icon: Icons.qr_code_scanner_outlined,
      text: 'WorkPermit QR',
      canEntry: true,
      canSkip: true,
    ));

    stepList.add(RegisterStep(
        icon: Icons.person_2_outlined,
        text: 'Customer Info 1',
        canEntry: true,
        canSkip: false));

    stepList.add(RegisterStep(
        icon: Icons.upload_file_outlined,
        text: 'Documents',
        canEntry: false,
        canSkip: false));

    stepList.add(RegisterStep(
        icon: Icons.category_outlined,
        text: 'Loan Type',
        canEntry: false,
        canSkip: false));

    stepList.add(RegisterStep(
        icon: Icons.calendar_month_outlined,
        text: 'Interview Appointment',
        canEntry: false,
        canSkip: false));

    return stepList;
  }
}
