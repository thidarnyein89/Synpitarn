import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/screens/loan/interview_appointment.dart';
import 'package:synpitarn/screens/profile/profile/additional_document.dart';
import 'package:synpitarn/screens/profile/profile/basic_information.dart';
import 'package:synpitarn/screens/profile/profile/change_phonenumber.dart';
import 'package:synpitarn/screens/profile/register/loan_type.dart';
import 'package:synpitarn/screens/profile/document_file.dart';
import 'package:synpitarn/screens/profile/register/customer_information.dart';
import 'package:synpitarn/screens/profile/register/additional_information.dart';
import 'package:synpitarn/screens/profile/register/work_permit.dart';

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
          text: 'workPermit',
          page: WorkPermitPage()),
    );

    stepList.add(StepData(
        loanFormState: 'qr_scan',
        icon: Icons.person_2_outlined,
        text: 'customerInformation',
        page: CustomerInformationPage()));

    stepList.add(StepData(
        loanFormState: 'customer_information',
        icon: Icons.upload_file_outlined,
        text: 'requiredDocuments',
        page: DocumentFilePage()));

    stepList.add(StepData(
        loanFormState: 'required_documents',
        icon: Icons.assignment_outlined,
        text: 'additionalInformation',
        page: Information2Page()));

    stepList.add(StepData(
        loanFormState: 'additional_information',
        icon: Icons.category_outlined,
        text: 'loanType',
        page: LoanTypePage()));

    stepList.add(StepData(
        loanFormState: 'choose_loan_type',
        icon: Icons.calendar_month_outlined,
        text: 'interviewAppointment',
        page: InterviewAppointmentPage(applicationData: null)));

    return stepList;
  }

  static List<StepData> getProfileSteps() {
    List<StepData> stepList = [];

    stepList.add(
      StepData(
          icon: Icons.phone_outlined,
          text: 'changePhoneNumber',
          page: ChangePhoneNumberPage()),
    );

    stepList.add(
      StepData(
          icon: Icons.person_2_outlined,
          text: 'basicInformation',
          page: BasicInformationPage()),
    );

    stepList.add(
      StepData(
          icon: Icons.upload_file_outlined,
          text: 'documents',
          page: DocumentFilePage()),
    );

    stepList.add(
      StepData(
          icon: Icons.upload_file_outlined,
          text: 'additionalDocuments',
          page: AdditionalDocumentPage()),
    );

    return stepList;
  }

  static List<StepData> getDocumentSteps() {
    List<StepData> stepList = [];

    stepList.add(
      StepData(
          icon: Icons.upload_file_outlined,
          text: 'documents',
          page: DocumentFilePage()),
    );

    stepList.add(
      StepData(
          icon: Icons.upload_file_outlined,
          text: 'additionalDocuments',
          page: AdditionalDocumentPage()),
    );

    return stepList;
  }
}
