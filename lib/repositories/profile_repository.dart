import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/models/user.dart';

class ProfileRepository {

  Future<UserResponse> getProfile(User loginUser) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/profile");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
    );

    return UserResponse.userResponseFromJson(response.body);
  }

  Future<UserResponse> editProfile( Map<String, dynamic> postBody, User loginUser) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/profile");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(postBody),
    );

    return UserResponse.userResponseFromJson(response.body);
  }

  Future<UserResponse> getOTP( Map<String, dynamic> postBody, User loginUser) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/change-number/send-otp");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(postBody),
    );

    return UserResponse.userResponseFromJson(response.body);
  }

  Future<UserResponse> changePhoneNumber( Map<String, dynamic> postBody, User loginUser) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/change-number");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(postBody),
    );

    return UserResponse.userResponseFromJson(response.body);
  }

}