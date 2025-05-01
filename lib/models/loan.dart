import 'dart:convert';

import 'package:synpitarn/models/document.dart';
import 'package:synpitarn/models/loan_schedule.dart';
import 'package:synpitarn/models/qrcode.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/models/admin.dart';

class Loan {
  int id = 0;
  String? applicationStatus = "";
  String? appointmentBranchDate = "";
  String? appointmentBranchTime = "";
  String? appointmentChannel = "";
  bool appointmentResubmit = false;
  String? appointmentDate = "";
  String? appointmentStatus = "";
  List<dynamic> branchSectionTimeSlot = [];
  String? appointmentTime = "";
  String? appointmentUrl = "";
  String? appliedAmount = "";
  String? approvedAmount = "";
  String? assigneeName = "";
  String? bankAccountNo = "";
  int bankId = 0;
  String? bankMobileNo = "";
  String? bankType = "";
  String? borrowerAge = "";
  String? borrowerCode = "";
  String? borrowerContactAddress = "";
  String? borrowerId = "";
  String? borrowerName = "";
  String? borrowerRegistrationAddress = "";
  String? borrowerTel = "";
  String? branch = "";
  int branchId = 0;
  String? branchCode = "";
  int clientId = 0;
  String? collectionFee = "";
  String? contractDate = "";
  String? contractEnd = "";
  String? contractNo = "";
  String? contractNoRef = "";
  String? contractStart = "";
  String? contractType = "";
  int currentLoanPlace = 0;
  String? createdAt = "";
  String? deletedAt = "";
  String? disbursedAmount = "";
  String? disbursementDate = "";
  String? disbursementDocument = "";
  int dueOn1 = 0;
  int dueOn2 = 0;
  int ect2Rate = 0;
  int ect3Rate = 0;
  String? firstCutoffDate = "";
  String? firstDueonDate = "";
  String? firstRepaymentDate = "";
  String? interestRate = "";
  String? invoiceDocument = "";
  int isFirstToan = 0;
  String lastRepaymentDate = "";
  String? loanApplicationStatus = "";
  String? loanAgreementDocument = "";
  String? loanCollectionFee = "";
  String? loanFineRate = "";
  int loanId = 0;
  String? loanInterestRate = "";
  String? loanLateInRate = "";
  int loanTerm = 0;
  String? loanType = "";
  int numberCutoff = 0;
  String? policyDate = "";
  int provinceId = 0;
  String principleAmount = "";
  QrCode qrcode = QrCode.defaultQrCode();
  String? rejectCode = "";
  String? rejectDate = "";
  String? repaymentAmountPerPeriod = "";
  String? repaymentDocument = "";
  String? receiptDocument = "";
  String? status = "";
  String? step = "";
  String? synpitarnAppointmentUpdateApiResponse = "";
  int termPeriod = 0;
  int thLanguageSkill = 0;
  String? timesPerMonth = "";
  bool toAppointmentBranch = false;
  String? updatedAt = "";
  int userId = 0;
  List<Document>? documentsRequest;
  User? client;
  Admin? user;
  List<LoanSchedule>? schedules;

  Loan(
      {required this.id,
      required this.applicationStatus,
      required this.appointmentBranchDate,
      required this.appointmentBranchTime,
      required this.appointmentChannel,
      required this.appointmentResubmit,
      required this.appointmentDate,
      required this.appointmentStatus,
      required this.appointmentTime,
      required this.appointmentUrl,
      required this.appliedAmount,
      required this.approvedAmount,
      required this.assigneeName,
      required this.bankAccountNo,
      required this.bankId,
      required this.bankMobileNo,
      required this.bankType,
      required this.borrowerAge,
      required this.borrowerCode,
      required this.borrowerContactAddress,
      required this.borrowerId,
      required this.borrowerName,
      required this.borrowerRegistrationAddress,
      required this.borrowerTel,
      required this.branch,
      required this.branchId,
      required this.branchCode,
      required this.branchSectionTimeSlot,
      required this.clientId,
      required this.collectionFee,
      required this.contractDate,
      required this.contractEnd,
      required this.contractNo,
      required this.contractNoRef,
      required this.contractStart,
      required this.contractType,
      required this.createdAt,
      required this.currentLoanPlace,
      required this.deletedAt,
      required this.disbursedAmount,
      required this.disbursementDate,
      required this.disbursementDocument,
      required this.documentsRequest,
      required this.dueOn1,
      required this.dueOn2,
      required this.ect2Rate,
      required this.ect3Rate,
      required this.firstCutoffDate,
      required this.firstDueonDate,
      required this.firstRepaymentDate,
      required this.interestRate,
      required this.invoiceDocument,
      required this.isFirstToan,
      required this.lastRepaymentDate,
      required this.loanApplicationStatus,
      required this.loanAgreementDocument,
      required this.loanCollectionFee,
      required this.loanFineRate,
      required this.loanId,
      required this.loanInterestRate,
      required this.loanLateInRate,
      required this.loanTerm,
      required this.loanType,
      required this.numberCutoff,
      required this.policyDate,
      required this.provinceId,
      required this.principleAmount,
      required this.qrcode,
      required this.receiptDocument,
      required this.rejectCode,
      required this.rejectDate,
      required this.repaymentAmountPerPeriod,
      required this.repaymentDocument,
      required this.status,
      required this.step,
      required this.synpitarnAppointmentUpdateApiResponse,
      required this.termPeriod,
      required this.thLanguageSkill,
      required this.timesPerMonth,
      required this.toAppointmentBranch,
      required this.updatedAt,
      required this.userId,
      required this.client,
      this.user,
      this.schedules});

  Loan.defaultLoan();

  factory Loan.loanResponseFromJson(String str) =>
      Loan.fromJson(json.decode(str));

  factory Loan.fromJson(Map<String, dynamic> json) {
    List<LoanSchedule> scheduleList = [];

    final scheduleJson = json['schedule'] ?? [];
    if (scheduleJson is List) {
      for (final scheduleMap in scheduleJson) {
        if (scheduleMap is Map<String, dynamic>) {
          scheduleList.add(LoanSchedule.fromJson(scheduleMap));
        }
      }
    }

    List<Document> documentList = [];

    final documentJson = json['documents_request'] ?? [];
    if (documentJson is List) {
      for (final documentMap in documentJson) {
        if (documentMap is Map<String, dynamic>) {
          documentList.add(Document.fromJson(documentMap));
        }
      }
    }

    if (json.containsKey('application')) {
      final applicationJson = json['application'] ?? {};
      final keyList = applicationJson.keys.toList();
      keyList.forEach((key) {
        if (!json.containsKey(key)) {
          json[key] = applicationJson[key];
        }
        if(key == 'status') {
          json['application_status'] = applicationJson['status'];
        }
      });
    }

    return Loan(
        id: json["id"] ?? 0,
        applicationStatus: json['application_status'] ?? "",
        appointmentBranchDate: json["appointment_branch_date"] ?? "",
        appointmentBranchTime: json["appointment_branch_time"] ?? "",
        appointmentChannel: json["appointment_channel"] ?? "",
        appointmentResubmit: json["appointment_resubmit"] ?? false,
        appointmentDate: json["appointment_date"] ?? "",
        appointmentStatus: json["appointment_status"] ?? "",
        appointmentTime: json["appointment_time"] ?? "",
        appointmentUrl: json["appointment_url"] ?? "",
        appliedAmount: json["applied_amount"] ?? "",
        approvedAmount: json["approved_amount"] ?? "",
        assigneeName: json["assignee_name"] ?? "",
        bankAccountNo: json["bank_account_no"] ?? "",
        bankId: json["bank_id"] ?? 0,
        bankMobileNo: json["bank_mobile_no"] ?? "",
        bankType: json["bank_type"] ?? "",
        borrowerAge: json["borrower_age"] ?? "",
        borrowerCode: json["borrower_code"] ?? "",
        borrowerContactAddress: json["borrower_contact_address"] ?? "",
        borrowerId: json["borrower_id"] ?? "",
        borrowerName: json["borrower_name"] ?? "",
        borrowerRegistrationAddress:
            json["borrower_registration_address"] ?? "",
        borrowerTel: json["borrower_tel"] ?? "",
        branch: json["branch"] ?? "",
        branchId: json["branch_id"] ?? 0,
        branchCode: json["branch_code"] ?? "",
        branchSectionTimeSlot: json["branch_section_time_slot"] ?? [],
        clientId: json["client_id"] ?? 0,
        collectionFee: json["collection_fee"] ?? "",
        contractDate: json["contract_date"] ?? "",
        contractEnd: json["contract_end"] ?? "",
        contractNo: json["contract_no"] ?? "",
        contractNoRef: json["contract_no_ref"] ?? "",
        contractStart: json["contract_start"] ?? "",
        contractType: json["contract_type"] ?? "",
        createdAt: json["created_at"] ?? "",
        currentLoanPlace: json["current_loan_place"] ?? 0,
        deletedAt: json["deleted_at"] ?? "",
        disbursedAmount: json["disbursed_amount"] ?? "",
        disbursementDate: json["disbursement_date"] ?? "",
        disbursementDocument: json["disbursement_document"] ?? "",
        documentsRequest: documentList,
        dueOn1: json["due_on_1"] ?? 0,
        dueOn2: json["due_on_2"] ?? 0,
        ect2Rate: json["ect2_rate"] ?? 0,
        ect3Rate: json["ect3_rate"] ?? 0,
        firstCutoffDate: json["first_cutoff_date"] ?? "",
        firstDueonDate: json["first_repayment_date"] ?? "",
        firstRepaymentDate: json["first_dueon_date"] ?? "",
        interestRate: json["interest_rate"] ?? "",
        invoiceDocument: json["invoice_document"] ?? "",
        isFirstToan: json["is_first_loan"] ?? 0,
        lastRepaymentDate: json["last_repayment_date"] ?? "",
        loanApplicationStatus: json['loan_application_status'] ?? "",
        loanAgreementDocument: json["loan_agreement_document"] ?? "",
        loanCollectionFee: json["loan_collection_fee"] ?? "",
        loanFineRate: json["loan_fine_rate"] ?? "",
        loanId: json["loan_id"] ?? 0,
        loanInterestRate: json["loan_interest_rate"] ?? "",
        loanLateInRate: json["loan_latein_rate"] ?? "",
        loanTerm: json["loan_term"] ?? 0,
        loanType: json["loan_type"] ?? "",
        numberCutoff: json["number_cutoff"] ?? 0,
        policyDate: json["policy_date"] ?? "",
        provinceId: json["province_id"] ?? 0,
        principleAmount: json['principle_amount'] ?? "",
        qrcode: json['qrcode'] != null
            ? QrCode.fromJson(json['qrcode'])
            : QrCode.defaultQrCode(),
        receiptDocument: json["receipt_document"] ?? "",
        rejectCode: json["reject_code"] ?? "",
        rejectDate: json["reject_date"] ?? "",
        repaymentAmountPerPeriod: json["repayment_amount_per_period"] ?? "",
        repaymentDocument: json["repayment_document"] ?? "",
        status: json["status"] ?? "",
        step: json["step"] ?? "",
        synpitarnAppointmentUpdateApiResponse:
            json["synpitarn_appointment_update_api_response"] ?? "",
        termPeriod: json["term_period"] ?? 0,
        thLanguageSkill: json["th_language_skill"] ?? 0,
        timesPerMonth: json["times_per_month"] ?? "",
        toAppointmentBranch: json["to_appointment_branch"] ?? false,
        updatedAt: json["updated_at"] ?? "",
        userId: json["user_id"] ?? 0,
        client: json.containsKey('client')
            ? User.fromJson(json["client"])
            : User.defaultUser(),
        user: json.containsKey('user')
            ? Admin.fromJson(json["user"])
            : Admin.defaultAdmin(),
        schedules: scheduleList);
  }
}
