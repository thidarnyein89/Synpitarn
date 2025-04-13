import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synpitarn/models/loan_application.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/login.dart';
import 'package:synpitarn/models/application.dart';
import 'package:synpitarn/models/workpermit.dart';

class ApplicationRepository {
  Future<Application> getApplication(User loginUser) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/loan/application");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
    );

    return Application.applicationResponseFromJson(response.body);
  }

  Future<Workpermit> saveWorkpermit(User loginUser) async {
    String url = "${AppConfig.BASE_URL}/${AppConfig
        .PATH}/store/e-workpermit-url";

    var post_body = {
      "url": loginUser.workPermitUrl
    };

    final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginUser.token}",
          "x-user-id": loginUser.id.toString(),
        },
        body: jsonEncode(post_body)
    ,);

    return Workpermit.workpermitResponseFromJson(response.body);
  }

  Future<Workpermit> checkWorkpermit(User loginUser) async {
    String url = "${AppConfig.BASE_URL}/${AppConfig
        .PATH}/e-workpermit-extractor?url=${Uri.encodeComponent(
        loginUser.workPermitUrl!)}&version_id=${AppConfig.VERSION_ID}";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
    );

    return Workpermit.workpermitResponseFromJson(response.body);
  }

  Future<Application> saveWorkpermitNull(LoanApplication loanApplication, User loginUser) async {
    var post_body = {
      "version_id": AppConfig.VERSION_ID,
      "input_data": loanApplication.toJsonForCustomerInformation()
    };

    String url = ("${AppConfig.BASE_URL}/${AppConfig
        .PATH}/form/type/default/step/qr_scan");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(post_body),
    );

    return Application.applicationResponseFromJson(response.body);
  }

  Future<Application> saveCustomerInformation(LoanApplication loanApplication, User loginUser) async {
    var post_body = {
      "version_id": AppConfig.VERSION_ID,
      "input_data": loanApplication.toJsonForCustomerInformation()
    };

    String url = ("${AppConfig.BASE_URL}/${AppConfig
        .PATH}/form/type/default/step/customer_information");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(post_body),
    );

    return Application.applicationResponseFromJson(response.body);
  }
}
