import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:synpitarn/data/loan_status.dart';
import 'package:synpitarn/models/guide.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/nrc.dart';
import 'package:synpitarn/models/aboutUs.dart';

class CommonService {

  Future<List<NRC>> readNRCData() async {
    final String response = await rootBundle.loadString('assets/json/nrcData.json');
    List<dynamic> jsonData = json.decode(response);
    List<NRC> nrcList = jsonData.map((data) => NRC.fromJson(data)).toList();
    return nrcList;
  }

  Future<List<Guide>> readGuideData() async {
    final String response = await rootBundle.loadString('assets/json/guide.json');
    List<dynamic> jsonData = json.decode(response);
    List<Guide> guideList = jsonData.map((data) => Guide.fromJson(data)).toList();
    return guideList;
  }

  Future<List<AboutUS>> readAboutUsData() async {
    final String response = await rootBundle.loadString('assets/json/aboutUs.json');
    List<dynamic> jsonData = json.decode(response);
    List<AboutUS> aboutList = jsonData.map((data) => AboutUS.fromJson(data)).toList();
    return aboutList;
  }

  static String formatDate(String rawDate) {
    if (rawDate != "") {
      DateTime parsedDate = DateTime.parse(rawDate);
      return DateFormat("dd MMM yyyy").format(parsedDate);
    }
    return "";
  }

  static String formatTime(String rawTime) {
    if (rawTime != "") {
      DateTime parsedTime = DateFormat("HH:mm:ss").parse(rawTime);
      return DateFormat("hh:mm a").format(parsedTime);
    }
    return "";
  }

  static int getDayCount(String date) {
    DateTime currentDate = DateTime.now();
    DateTime previousDate = DateTime.parse(date);
    return currentDate.difference(previousDate).inDays;
  }

  static String getLoanStatus(String status) {
    String loanStatus = "";

    if (LoanStatus.PENDING_STATUS.contains(status)) {
      loanStatus = 'pending';
    }
    if (LoanStatus.PRE_APPROVE_STATUS.contains(status)) {
      loanStatus = 'pre-approved';
    }
    if (LoanStatus.DISBURSE_STATUS.contains(status)) {
      loanStatus = 'approved';
    }
    if (LoanStatus.REJECT_STATUS.contains(status)) {
      loanStatus = 'reject';
    }
    if (LoanStatus.POSTPONE_STATUS.contains(status)) {
      loanStatus = 'postpone';
    }

    return loanStatus;
  }

  static String getLoanSize(Loan loanData) {
    print("Application Status ${loanData.applicationStatus} Loan Status ${loanData.status}");
    String loanSize = "";
    if (LoanStatus.PRE_APPROVE_STATUS.contains(loanData.status)) {
      loanSize = loanData.approvedAmount ?? "0";
    }
    else if (LoanStatus.DISBURSE_STATUS.contains(loanData.status)) {
      loanSize = loanData.disbursedAmount ?? "0";
    }
    else {
      loanSize = loanData.appliedAmount ?? "0";
    }

    return "$loanSize  Baht";
  }

}