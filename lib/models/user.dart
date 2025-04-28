import 'dart:convert';

class User {
  int id = 0;
  String name = '';
  String phoneNumber = '';
  String dob = '';
  String provinceOfWork = '';
  String provinceOfResident = '';
  String? districtOfResident = '';
  String incomeType = '';
  double salary = 0.0;
  String? email = '';
  String active = '';
  String language = '';
  String? imageUrl = '';
  double creditScore = 0.0;
  String createdAt = '';
  String updatedAt = '';
  String? deletedAt = '';
  String? oneSignalUserId = '';
  String? rejectCode = '';
  String lang = '';
  String? workPermitUrl = '';
  String identityNumber = '';
  String passport = '';
  String status = '';
  String token = '';
  bool loanApplicationSubmitted = false;
  String loanFormState = '';
  int age = 0;
  String? borrowerCode = '';
  String provinceOfWorkText = '';
  String provinceOfResidentText = '';
  String code = ''; //For Password in Login Page
  bool forgetPassword = false; //For Determine Forget OR Confirm in OTP Page
  String type = ''; //For PinType
  String authToken = ''; //For Token from SetPassword
  String nameOfEmployment = ''; //For QR Scan Response Data
  String officeLocation = ''; //For QR Scan Response Data

  User.defaultUser();

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.dob,
    required this.provinceOfWork,
    required this.provinceOfResident,
    this.districtOfResident,
    required this.incomeType,
    required this.salary,
    this.email,
    required this.active,
    required this.language,
    this.imageUrl,
    required this.creditScore,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.oneSignalUserId,
    this.rejectCode,
    required this.lang,
    this.workPermitUrl,
    required this.identityNumber,
    required this.passport,
    required this.status,
    required this.token,
    required this.loanApplicationSubmitted,
    required this.loanFormState,
    required this.age,
    this.borrowerCode,
    required this.provinceOfWorkText,
    required this.provinceOfResidentText,
    required this.code,
    required this.forgetPassword,
    required this.type,
    required this.authToken,
    required this.nameOfEmployment,
    required this.officeLocation,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      dob: (json['dob'] == null || json['dob'] == '0000-00-00') ? "" : json['dob'],
      provinceOfWork: json['province_of_work'] ?? "",
      provinceOfResident: json['province_of_resident'] ?? "",
      districtOfResident: json['district_of_resident'] ?? "",
      incomeType: json['income_type'] ?? "",
      salary: (json['salary'] != null && (json['salary'] is num))
          ? (json['salary'] as num).toDouble()
          : 0.0,
      email: json['email'] ?? "",
      active: json['active'] ?? "",
      language: json['language'] ?? "",
      imageUrl: json['image_url'] ?? "",
      creditScore: double.tryParse(json['credit_score'].toString()) ?? 0.0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
      oneSignalUserId: json['one_signal_user_id'] ?? "",
      rejectCode: json['reject_code'] ?? "",
      lang: json['lang'] ?? "",
      workPermitUrl: json['work_permit_url'] ?? "",
      identityNumber: json['identity_number'] ?? "",
      passport: json['passport'] ?? "",
      status: json['status'] ?? "",
      token: json['token'] ?? "",
      loanApplicationSubmitted: json['loan_application_submitted'] ?? false,
      loanFormState: json['loan_form_state'] ?? "",
      age: json['age'] ?? 0,
      borrowerCode: json['borrower_code'] ?? "",
      provinceOfWorkText: json['province_of_work_text'] ?? "",
      provinceOfResidentText: json['province_of_resident_text'] ?? "",
      code: json.containsKey("code") ? json["code"] ?? json["code"] : "",
      forgetPassword: json.containsKey("forget_password") ? json["forget_password"] is bool ? json["forget_password"] : false : false,
      type: json.containsKey("type") ? json["type"] ?? json["type"] : "",
      authToken: json.containsKey("auth_token") ? json["auth_token"] ?? json["auth_token"] : "",
      nameOfEmployment: json['name_of_employment'] ?? "",
      officeLocation: json['office_location'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'dob': dob,
      'province_of_work': provinceOfWork,
      'province_of_resident': provinceOfResident,
      'district_of_resident': districtOfResident,
      'income_type': incomeType,
      'salary': salary,
      'email': email,
      'active': active,
      'language': language,
      'image_url': imageUrl,
      'credit_score': creditScore,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'one_signal_user_id': oneSignalUserId,
      'reject_code': rejectCode,
      'lang': lang,
      'work_permit_url': workPermitUrl,
      'identity_number': identityNumber,
      'passport': passport,
      'status': status,
      'token': token,
      'loan_application_submitted': loanApplicationSubmitted,
      'loan_form_state': loanFormState,
      'age': age,
      'borrower_code': borrowerCode,
      'province_of_work_text': provinceOfWorkText,
      'province_of_resident_text': provinceOfResidentText,
      'code': code,
      'forget_password': forgetPassword,
      'type': type,
      'auth_token': authToken,
      'name_of_employment': nameOfEmployment,
      'office_location': officeLocation
    };
  }

  String userResponseToJson() => json.encode(toJson());

  factory User.userResponseFromJson(String source) => User.fromJson(json.decode(source));
}
