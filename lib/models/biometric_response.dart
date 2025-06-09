import 'dart:convert';
import 'response.dart';
import 'meta.dart';
import 'biometric.dart';

class BiometricResponse {
  final Response response;
  final Meta meta;
  final Biometric data;

  BiometricResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory BiometricResponse.biometricResponseFromJson(String str) =>
      BiometricResponse.fromJson(json.decode(str));

  factory BiometricResponse.fromJson(Map<String, dynamic> json) {
    Biometric biometric = Biometric.defaultBiometric();

    if (json.containsKey("data")) {
      biometric = Biometric.fromJson(json["data"]);
    }

    return BiometricResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: biometric,
    );
  }
}
