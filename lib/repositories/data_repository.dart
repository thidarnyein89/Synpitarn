import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/user.dart';

class DataRepository {

  Future<DataResponse> getLoanTypes() async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/data/loan-types");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    return DataResponse.dataResponseFromJson(response.body);
  }

  Future<DataResponse> getTimesPerMonth() async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/data/times-per-month");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    return DataResponse.dataResponseFromJson(response.body);
  }

  Future<DataResponse> getProvinces() async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/data/provinces");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    return DataResponse.dataResponseFromJson(response.body);
  }

  Future<DataResponse> getAvailableTime(Map<String, dynamic> postBody, User loginUser) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/appointment/available-time-slots");

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
