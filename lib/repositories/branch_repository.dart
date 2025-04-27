import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/branch_response.dart';
import 'package:synpitarn/models/user.dart';

class BranchRepository {

  Future<BranchResponse> getBranches() async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/data/branches");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    return BranchResponse.branchResponseFromJson(response.body);
  }

  Future<BranchResponse> saveAppointment(
      Map<String, dynamic> postBody, User loginUser) async {

    String url =
    ("${AppConfig.BASE_URL}/${AppConfig.PATH}/loan/branch/appointment");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(postBody),
    );

    return BranchResponse.branchResponseFromJson(response.body);
  }
}