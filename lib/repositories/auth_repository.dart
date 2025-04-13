import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/login_response.dart';

class AuthRepository {
  Future<LoginResponse> register(User loginRequest) async {
    var post_body = {
      "identity_number": loginRequest.identityNumber,
      "passport": loginRequest.passport,
      "phone_number": loginRequest.phoneNumber,
      "status": loginRequest.status
    };

    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/auth/register-only-phone-no");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post_body),
    );

    return LoginResponse.loginResponseFromJson(response.body);
  }

  Future<LoginResponse> login(User loginRequest) async {
    var post_body = {
      "code": loginRequest.code,
      "phone_number": loginRequest.phoneNumber,
      "type": loginRequest.type
    };

    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/auth/login");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post_body),
    );

    return LoginResponse.loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getOTP(User loginRequest) async {
    var post_body = {
      "forget_password": loginRequest.forgetPassword,
      "phone_number": loginRequest.phoneNumber
    };

    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/auth/send-otp");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post_body),
    );

    return LoginResponse.loginResponseFromJson(response.body);
  }

  Future<LoginResponse> checkOTP(User loginRequest) async {
    var post_body = {
      "code": loginRequest.code,
      "forget_password": loginRequest.forgetPassword,
      "phone_number": loginRequest.phoneNumber
    };

    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/auth/check-otp");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post_body),
    );

    return LoginResponse.loginResponseFromJson(response.body);
  }

  Future<LoginResponse> setPassword(User loginRequest) async {
    var post_body = {
      "auth_token": loginRequest.token,
      "forget_password": loginRequest.forgetPassword,
      "phone_number": loginRequest.phoneNumber,
      "password": loginRequest.code
    };

    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/auth/set-password");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post_body),
    );

    return LoginResponse.loginResponseFromJson(response.body);
  }
}