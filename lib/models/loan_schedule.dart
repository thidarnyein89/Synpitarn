import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoanSchedule {
  int clientId = 0;
  String collectionFee = "";
  String createdAt = "";
  int currentScheduleNo = 0;
  String interestAmount = "";
  int isPaymentDone = 0;
  int loanId = 0;
  String loanRepayment = "";
  String otherFee = "";
  String outstandingPayment = "";
  String penaltyFee = "";
  String period = "";
  String pmtAmount = "";
  String pmtDate = "";
  String pmtRemainAmount = "";
  String remainBalance = "";
  String remark = "";
  String repaymentAmount = "";
  String repaymentChannel = "";
  String repaymentDate = "";
  String repaymentTime = "";
  String serviceFee = "";
  String status = "";
  int totalRepaymentAmount = 0;

  LoanSchedule.defaultLoanSchedule();

  LoanSchedule({
    required this.clientId,
    required this.collectionFee,
    required this.createdAt,
    required this.currentScheduleNo,
    required this.interestAmount,
    required this.isPaymentDone,
    required this.loanId,
    required this.loanRepayment,
    required this.otherFee,
    required this.outstandingPayment,
    required this.penaltyFee,
    required this.period,
    required this.pmtAmount,
    required this.pmtDate,
    required this.pmtRemainAmount,
    required this.remainBalance,
    required this.remark,
    required this.repaymentAmount,
    required this.repaymentChannel,
    required this.repaymentDate,
    required this.repaymentTime,
    required this.serviceFee,
    required this.status,
    required this.totalRepaymentAmount,
  });

  factory LoanSchedule.fromJson(Map<String, dynamic> json) {
    final totalRepaymentAmountJson = json['total_repayment_amount'];
    int totalRepaymentAmountParsed = 0;

    if (totalRepaymentAmountJson is int) {
      totalRepaymentAmountParsed = totalRepaymentAmountJson;
    } else if (totalRepaymentAmountJson is double) {
      totalRepaymentAmountParsed = totalRepaymentAmountJson.round();
    } else if (totalRepaymentAmountJson != null) {
      totalRepaymentAmountParsed = int.tryParse(totalRepaymentAmountJson.toString()) ?? 0;
    }

    return LoanSchedule(
      clientId: json['client_id'] ?? 0,
      collectionFee: json['collection_fee'] ?? "",
      createdAt: json['created_at'] ?? "",
      currentScheduleNo: json['current_schedule_no'] ?? 0,
      interestAmount: json['interest_amount'] ?? "",
      isPaymentDone: json['is_payment_done'] ?? 0,
      loanId: json['loan_id'] ?? 0,
      loanRepayment: json['loan_repayment'] ?? "",
      otherFee: json['other_fee'] ?? "",
      outstandingPayment: json['outstanding_payment'] ?? "",
      penaltyFee: json['penalty_fee'] ?? "",
      period: json['period'] ?? "",
      pmtAmount: json['pmt_amount'] ?? "",
      pmtDate: json['pmt_date'] ?? "",
      pmtRemainAmount: json['pmt_remain_amount'] ?? "",
      remainBalance: json['remain_balance'] ?? "",
      remark: json['remark'] ?? "",
      repaymentAmount: json['repayment_amount'] ?? "",
      repaymentChannel: json['repayment_channel'] ?? "",
      repaymentDate: json['repayment_date'] ?? "",
      repaymentTime: json['repayment_time'] ?? "",
      serviceFee: json['service_fee'] ?? "",
      status: json['status'] ?? "",
      totalRepaymentAmount: totalRepaymentAmountParsed,
    );
  }
}
