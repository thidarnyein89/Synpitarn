import 'dart:convert';

import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/models/admin.dart';

class Loan {
  int id = 0;
  String? contractDate = "";
  String? contractEnd = "";
  String? contractStart = "";
  String? contractNo = "";
  String? contractNoRef = "";
  String? appointmentDate = "";
  String? appointmentTime = "";
  String? appointmentUrl = "";
  String? appointmentChannel = "";
  String? appointmentStatus = "";
  String? branch = "";
  int provinceId = 0;
  int branchId = 0;
  String? step = "";
  String? status = "";
  String? collectionFee = "";
  String? appliedAmount = "";
  String? approvedAmount = "";
  String? disbursedAmount = "";
  String? loanType = "";
  int isFirstToan = 0;
  String? loanTerm = "";
  String? timesPerMonth = "";
  String? loanInterestRate = "";
  int clientId = 0;
  int userId = 0;
  String? createdAt = "";
  String? updatedAt = "";
  String? deletedAt = "";
  int borrowerId = 0;
  int borrowerCode = 0;
  String? borrowerName = "";
  String? borrowerAge = "";
  String? borrowerTel = "";
  String? borrowerRegistrationAddress = "";
  String? borrowerContactAddress = "";
  String? contractType = "";
  String? branchCode = "";
  String? loanLateInRate = "";
  String? loanFineRate = "";
  String? loanCollectionFee = "";
  String? repaymentAmountPerPeriod = "";
  int numberCutoff = 0;
  int dueOn1 = 0;
  int dueOn2 = 0;
  int ect2Rate = 0;
  int ect3Rate = 0;
  String? disbursementDate = "";
  String? firstCutoffDate = "";
  String? firstDueonDate = "";
  String? policyDate = "";
  int bankId = 0;
  String? bankType = "";
  String? bankAccountNo = "";
  String? bankMobileNo = "";
  String? rejectCode = "";
  String? documentsRequest = "";
  String? loanAgreementDocument = "";
  String? disbursementDocument = "";
  String? repaymentDocument = "";
  String? invoiceDocument = "";
  String? receiptDocument = "";
  String? appointmentBranchDate = "";
  String? appointmentBranchTime = "";
  String? rejectDate = "";
  int currentLoanPlace = 0;
  String? thLanguageSkill = "";
  String? synpitarnAppointmentUpdateApiResponse = "";
  bool appointmentResubmit = false;
  String? assigneeName = "";
  List<dynamic> branchSectionTimeSlot = [];
  bool toAppointmentBranch = false;
  String? loanId = "";
  User client;
  Admin user;

  Loan({
    required this.id,
    required this.contractDate,
    required this.contractEnd,
    required this.contractStart,
    required this.contractNo,
    required this.contractNoRef,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentUrl,
    required this.appointmentChannel,
    required this.appointmentStatus,
    required this.branch,
    required this.provinceId,
    required this.branchId,
    required this.step,
    required this.status,
    required this.collectionFee,
    required this.appliedAmount,
    required this.approvedAmount,
    required this.disbursedAmount,
    required this.loanType,
    required this.isFirstToan,
    required this.loanTerm,
    required this.timesPerMonth,
    required this.loanInterestRate,
    required this.clientId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.borrowerId,
    required this.borrowerCode,
    required this.borrowerName,
    required this.borrowerAge,
    required this.borrowerTel,
    required this.borrowerRegistrationAddress,
    required this.borrowerContactAddress,
    required this.contractType,
    required this.branchCode,
    required this.loanLateInRate,
    required this.loanFineRate,
    required this.loanCollectionFee,
    required this.repaymentAmountPerPeriod,
    required this.numberCutoff,
    required this.dueOn1,
    required this.dueOn2,
    required this.ect2Rate,
    required this.ect3Rate,
    required this.disbursementDate,
    required this.firstCutoffDate,
    required this.firstDueonDate,
    required this.policyDate,
    required this.bankId,
    required this.bankType,
    required this.bankAccountNo,
    required this.bankMobileNo,
    required this.rejectCode,
    required this.documentsRequest,
    required this.loanAgreementDocument,
    required this.disbursementDocument,
    required this.repaymentDocument,
    required this.invoiceDocument,
    required this.receiptDocument,
    required this.appointmentBranchDate,
    required this.appointmentBranchTime,
    required this.rejectDate,
    required this.currentLoanPlace,
    required this.thLanguageSkill,
    required this.synpitarnAppointmentUpdateApiResponse,
    required this.appointmentResubmit,
    required this.assigneeName,
    required this.branchSectionTimeSlot,
    required this.toAppointmentBranch,
    required this.loanId,
    required this.client,
    required this.user,
  });

  Loan.defaultLoan(this.client, this.user);

  factory Loan.loanResponseFromJson(String str) =>
      Loan.fromJson(json.decode(str));

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json["id"] ?? 0,
      contractDate: json["contract_date"] ?? "",
      contractEnd: json["contract_end"] ?? "",
      contractStart: json["contract_start"] ?? "",
      contractNo: json["contract_no"] ?? "",
      contractNoRef: json["contract_no_ref"] ?? "",
      appointmentDate: json["appointment_date"] ?? "",
      appointmentTime: json["appointment_time"] ?? "",
      appointmentUrl: json["appointment_url"] ?? "",
      appointmentChannel: json["appointment_channel"] ?? "",
      appointmentStatus: json["appointment_status"] ?? "",
      branch: json["branch"] ?? "",
      provinceId: json["province_id"] ?? 0,
      branchId: json["branch_id"] ?? 0,
      step: json["step"] ?? "",
      status: json["status"] ?? "",
      collectionFee: json["collection_fee"] ?? "",
      appliedAmount: json["applied_amount"] ?? "",
      approvedAmount: json["approved_amount"] ?? "",
      disbursedAmount: json["disbursed_amount"] ?? "",
      loanType: json["loan_type"] ?? "",
      isFirstToan: json["is_first_loan"] ?? 0,
      loanTerm: json["loan_term"] ?? "",
      timesPerMonth: json["times_per_month"] ?? "",
      loanInterestRate: json["loan_interest_rate"] ?? "",
      clientId: json["client_id"] ?? 0,
      userId: json["user_id"] ?? 0,
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      deletedAt: json["deleted_at"] ?? "",
      borrowerId: json["borrower_id"] ?? 0,
      borrowerCode: json["borrower_code"] ?? 0,
      borrowerName: json["borrower_name"] ?? "",
      borrowerAge: json["borrower_age"] ?? "",
      borrowerTel: json["borrower_tel"] ?? "",
      borrowerRegistrationAddress: json["borrower_registration_address"] ?? "",
      borrowerContactAddress: json["borrower_contact_address"] ?? "",
      contractType: json["contract_type"] ?? "",
      branchCode: json["branch_code"] ?? "",
      loanLateInRate: json["loan_latein_rate"] ?? "",
      loanFineRate: json["loan_fine_rate"] ?? "",
      loanCollectionFee: json["loan_collection_fee"] ?? "",
      repaymentAmountPerPeriod: json["repayment_amount_per_period"] ?? "",
      numberCutoff: json["number_cutoff"] ?? 0,
      dueOn1: json["due_on_1"] ?? 0,
      dueOn2: json["due_on_2"] ?? 0,
      ect2Rate: json["ect2_rate"] ?? 0,
      ect3Rate: json["ect3_rate"] ?? 0,
      disbursementDate: json["disbursement_date"] ?? "",
      firstCutoffDate: json["first_cutoff_date"] ?? "",
      firstDueonDate: json["first_dueon_date"] ?? "",
      policyDate: json["policy_date"] ?? "",
      bankId: json["bank_id"] ?? 0,
      bankType: json["bank_type"] ?? "",
      bankAccountNo: json["bank_account_no"] ?? "",
      bankMobileNo: json["bank_mobile_no"] ?? "",
      rejectCode: json["reject_code"] ?? "",
      documentsRequest: json["documents_request"] ?? "",
      loanAgreementDocument: json["loan_agreement_document"] ?? "",
      disbursementDocument: json["disbursement_document"] ?? "",
      repaymentDocument: json["repayment_document"] ?? "",
      invoiceDocument: json["invoice_document"] ?? "",
      receiptDocument: json["receipt_document"] ?? "",
      appointmentBranchDate: json["appointment_branch_date"] ?? "",
      appointmentBranchTime: json["appointment_branch_time"] ?? "",
      rejectDate: json["reject_date"] ?? "",
      currentLoanPlace: json["current_loan_place"] ?? 0,
      thLanguageSkill: json["th_language_skill"] ?? "",
      synpitarnAppointmentUpdateApiResponse:
          json["synpitarn_appointment_update_api_response"] ?? "",
      appointmentResubmit: json["appointment_resubmit"] ?? false,
      assigneeName: json["assignee_name"] ?? "",
      branchSectionTimeSlot: json["branch_section_time_slot"],
      toAppointmentBranch: json["to_appointment_branch"] ?? false,
      loanId: json["loan_id"] ?? "",
      client: User.fromJson(json["client"]),
      user: Admin.fromJson(json["user"]),
    );
  }
}
