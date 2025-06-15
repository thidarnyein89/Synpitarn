import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/models/biometric.dart';
import 'package:synpitarn/models/biometric_response.dart';
import 'package:synpitarn/models/user.dart';

class BiometricRepository {
  Future<BiometricResponse> register(
    Biometric biometricRequest,
    User loginUser,
  ) async {
    var post_body = {"public_key": biometricRequest.publicKey};

    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/biometric/register");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(post_body),
    );

    print("=============");
    print(url);
    print(post_body);
    print(response.body);
    return BiometricResponse.biometricResponseFromJson(response.body);
  }

  Future<BiometricResponse> challenge(Biometric biometricRequest) async {
    var post_body = {"biometric_uuid": biometricRequest.biometricUuid};

    String url =
        ("${AppConfig.BASE_URL}/${AppConfig.PATH}/auth/biometric/challenge");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post_body),
    );

    return BiometricResponse.biometricResponseFromJson(response.body);
  }

  Future<UserResponse> login(Biometric biometricRequest) async {
    var post_body = {
      "biometric_uuid": biometricRequest.biometricUuid,
      "signature": biometricRequest.signature,
    };

    String url =
        ("${AppConfig.BASE_URL}/${AppConfig.PATH}/auth/biometric/login");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post_body),
    );

    print("=============");
    print(url);
    print(post_body);
    print(response.body);
    return UserResponse.userResponseFromJson(response.body);
  }
}
