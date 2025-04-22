import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/loan_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/loan_application_response.dart';
import 'package:synpitarn/models/workpermit_response.dart';

class LoanRepository {
  Future<LoanApplicationResponse> getApplication(User loginUser) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/loan/application");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
    );

    return LoanApplicationResponse.loanApplicationResponseFromJson(response.body);
  }

  Future<LoanResponse> getLoanHistory(User loginUser) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/loan-history?page=1");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
    );

    return LoanResponse.loanResponseFromJson(response.body);
  }

  Future<WorkPermitResponse> saveWorkpermit(User loginUser) async {
    String url =
        "${AppConfig.BASE_URL}/${AppConfig.PATH}/store/e-workpermit-url";

    var post_body = {"url": loginUser.workPermitUrl};

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(post_body),
    );

    return WorkPermitResponse.workPermitResponseFromJson(response.body);
  }

  Future<Map<String, dynamic>> checkWorkpermit(int versionId, User loginUser) async {
    String url =
        "${AppConfig.BASE_URL}/${AppConfig.PATH}/e-workpermit-extractor?url=${Uri.encodeComponent(loginUser.workPermitUrl!)}&version_id=$versionId";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
    );

    return jsonDecode(response.body);
  }

  Future<DataResponse> saveLoanApplicationStep(
      Map<String, dynamic> postBody, User loginUser, String stepName) async {

    String url =
    ("${AppConfig.BASE_URL}/${AppConfig.PATH}/form/type/default/step/$stepName");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(postBody),
    );

    print(response.body);
    return DataResponse.dataResponseFromJson(response.body);
  }

  Future<DataResponse> saveInterviewAppointment(
      Map<String, dynamic> postBody, User loginUser) async {

    String url =
    ("${AppConfig.BASE_URL}/${AppConfig.PATH}/appointment/submit");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(postBody),
    );

    return DataResponse.dataResponseFromJson(response.body);
  }

  Future<DataResponse> updateInterviewAppointment(
     int id, Map<String, dynamic> postBody, User loginUser) async {

    String url =
    ("${AppConfig.BASE_URL}/${AppConfig.PATH}/appointment/update/$id");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(postBody),
    );

    return DataResponse.dataResponseFromJson(response.body);
  }
}
