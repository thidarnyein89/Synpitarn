import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/screens/loan/interview_appointment.dart';
import 'package:synpitarn/screens/profile/loan_type.dart';
import 'package:synpitarn/screens/profile/document_file.dart';
import 'package:synpitarn/screens/profile/customer_information.dart';
import 'package:synpitarn/screens/profile/additional_information.dart';
import 'package:synpitarn/screens/profile/work_permit.dart';

class StepData {

  String? loanFormState;
  IconData icon = Icons.qr_code_scanner_outlined;
  String text = "";
  Widget page;
  bool? isFinish = false;
  bool? isCurrent = false;
  bool? isForCard = false;

  StepData(
      {this.loanFormState,
      required this.icon,
      required this.text,
      required this.page,
      this.isFinish,
      this.isCurrent,
      this.isForCard});

  static List<StepData> getRegisterSteps() {
    List<StepData> stepList = [];

    stepList.add(
      StepData(
          icon: Icons.qr_code_scanner_outlined,
          text: 'Work Permit',
          page: WorkPermitPage()),
    );

    stepList.add(StepData(
        loanFormState: 'qr_scan',
        icon: Icons.person_2_outlined,
        text: 'Customer Information',
        page: CustomerInformationPage()));

    stepList.add(StepData(
        loanFormState: 'customer_information',
        icon: Icons.upload_file_outlined,
        text: 'Required Documents',
        page: DocumentFilePage()));

    stepList.add(StepData(
        loanFormState: 'required_documents',
        icon: Icons.assignment_outlined,
        text: 'Additional Information',
        page: Information2Page()));

    stepList.add(StepData(
        loanFormState: 'additional_information',
        icon: Icons.category_outlined,
        text: 'Loan Type',
        page: LoanTypePage()));

    stepList.add(StepData(
        loanFormState: 'choose_loan_type',
        icon: Icons.calendar_month_outlined,
        text: 'Interview Appointment',
        page: InterviewAppointmentPage(applicationData: null)));

    return stepList;
  }

  static List<StepData> getProfileSteps() {
    List<StepData> stepList = [];

    stepList.add(
      StepData(
          icon: Icons.person_2_outlined,
          text: 'Basic Information',
          page: CustomerInformationPage()),
    );

    stepList.add(
      StepData(
          icon: Icons.upload_file_outlined,
          text: 'Documents',
          page: DocumentFilePage()),
    );

    stepList.add(
      StepData(
          icon: Icons.upload_file_outlined,
          text: 'Additional Documents',
          page: DocumentFilePage()),
    );

    return stepList;
  }
}
