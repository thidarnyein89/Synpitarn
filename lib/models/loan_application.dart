import 'dart:convert';
import 'dart:core';

class LoanApplication {
  String debit = "";
  String monthlyRepaymentForDebit = "";
  String salary = "";
  String loanAmount = "";
  String socialLinks = "";
  String yearWorkingInThailand = "";
  String monthWorkingInThailand = "";
  String loanTermYear = "";
  String loanTermMonth = "";
  List<String> mainPurposeOfLoan = [];
  String otherReasonForMainPurposeOfLoan = "";
  String typeOfWork = "";
  String industry = "";
  String referralCode = "";
  String bankBook = "";
  String payslip = "";
  String visa = "";
  String passport = "";
  String workpermitFront = "";
  String workpermitBack = "";
  String name = "";
  String martialStatus = "";
  String residence = "";
  String nameOfEmployment = "";
  String officeLocation = "";
  String dob = "";
  String branch = "";
  String education = "";
  String gender = "";
  String nationality = "";
  String testing = "";
  String passportNumber = "";

  LoanApplication(
      {required this.debit,
      required this.monthlyRepaymentForDebit,
      required this.salary,
      required this.loanAmount,
      required this.socialLinks,
      required this.yearWorkingInThailand,
      required this.monthWorkingInThailand,
      required this.loanTermYear,
      required this.loanTermMonth,
      required this.mainPurposeOfLoan,
      required this.otherReasonForMainPurposeOfLoan,
      required this.typeOfWork,
      required this.industry,
      required this.referralCode,
      required this.bankBook,
      required this.payslip,
      required this.visa,
      required this.passport,
      required this.workpermitFront,
      required this.workpermitBack,
      required this.name,
      required this.martialStatus,
      required this.residence,
      required this.nameOfEmployment,
      required this.officeLocation,
      required this.dob,
      required this.branch,
      required this.education,
      required this.gender,
      required this.nationality,
      required this.testing,
      required this.passportNumber});

  LoanApplication.defaultLoanApplication();

  factory LoanApplication.applicationResponseFromJson(String str) =>
      LoanApplication.fromJson(json.decode(str));

  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      debit: json["debit"] ?? "",
      monthlyRepaymentForDebit: json["monthly_repayment_for_debit"] ?? "",
      salary: json["salary"] ?? "",
      loanAmount: json["loan_amount"] ?? "",
      socialLinks: json["social_links"] ?? "",
      yearWorkingInThailand: json["year_working_in_thailand"] ?? "",
      monthWorkingInThailand: json["month_working_in_thailand"] ?? "",
      loanTermYear: json["loan_term_year"] ?? "",
      loanTermMonth: json["loan_term_month"] ?? "",
      mainPurposeOfLoan: json["main_purpose_of_loan"] ?? [],
      otherReasonForMainPurposeOfLoan:
          json["other_reason_for_main_purpose_of_loan"] ?? "",
      typeOfWork: json["type_of_work"] ?? "",
      industry: json["industry"] ?? "",
      referralCode: json["referral_code"] ?? "",
      bankBook: json["bank_book"] ?? "",
      payslip: json["payslip"] ?? "",
      visa: json["visa"] ?? "",
      passport: json["passport"] ?? "",
      workpermitFront: json["workpermit_front"] ?? "",
      workpermitBack: json["workpermit_back"] ?? "",
      name: json["name"] ?? "",
      martialStatus: json["martial_status"] ?? "",
      residence: json["residence"] ?? "",
      nameOfEmployment: json["name_of_employment"] ?? "",
      officeLocation: json["office_location"] ?? "",
      dob: json["dob"] ?? "",
      branch: json["branch"] ?? "",
      education: json["education"] ?? "",
      gender: json["gender"] ?? "",
      nationality: json["nationality"] ?? "",
      testing: json["testing"] ?? "",
      passportNumber: json["passport_number"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debit': debit,
      'monthly_repayment_for_debit': monthlyRepaymentForDebit,
      'salary': salary,
      'loan_amount': loanAmount,
      'social_links': socialLinks,
      'year_working_in_thailand': yearWorkingInThailand,
      'month_working_in_thailand': monthWorkingInThailand,
      'loan_term_year': loanTermYear,
      'loan_term_month': loanTermMonth,
      'main_purpose_of_loan': mainPurposeOfLoan,
      'other_reason_for_main_purpose_of_loan': otherReasonForMainPurposeOfLoan,
      'type_of_work': typeOfWork,
      'industry': industry,
      'referral_code': referralCode,
      'bank_book': bankBook,
      'payslip': payslip,
      'visa': visa,
      'passport': passport,
      'workpermit_front': workpermitFront,
      'workpermit_back': workpermitBack,
      'name': name,
      'martial_status': martialStatus,
      'residence': residence,
      'name_of_employment': nameOfEmployment,
      'office_location': officeLocation,
      'dob': dob,
      'branch': branch,
      'education': education,
      'gender': gender,
      'nationality': nationality,
      'testing': testing,
      'passport_number': passportNumber
    };
  }

  String toJsonForCustomerInformation() {
    final allData = {
      'name': name,
      'martial_status': martialStatus,
      'residence': residence,
      'name_of_employment': nameOfEmployment,
      'office_location': officeLocation,
      'dob': dob,
      'branch': branch,
      'education': education,
      'gender': gender,
      'nationality': nationality,
      'testing': testing
    };

    return json.encode(allData);
  }

  String toJsonForAdditionalInformation() {
    final customerInfo = json.decode(toJsonForCustomerInformation());

    final allData = {
      ...customerInfo,
      'year_working_in_thailand': yearWorkingInThailand,
      'month_working_in_thailand': monthWorkingInThailand,
      'type_of_work': typeOfWork,
      'industry': industry,
      'debit': debit,
      'monthly_repayment_for_debit': monthlyRepaymentForDebit,
      'salary': salary,
      'loan_amount': loanAmount,
      'loan_term_year': loanTermYear,
      'loan_term_month': loanTermMonth,
      'social_links': socialLinks,
      'referral_code': referralCode
    };

    return json.encode(allData);
  }
}
