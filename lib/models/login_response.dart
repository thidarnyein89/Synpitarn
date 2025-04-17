import 'dart:convert';
import 'package:synpitarn/models/user.dart';
import 'response.dart';
import 'meta.dart';

class LoginResponse {
  final Response response;
  final Meta meta;
  final User data;

  LoginResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory LoginResponse.loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    User user = User.defaultUser();

    if(json.containsKey("data")) {
      if(json["data"] is int) {
        user.code = json["data"].toString();
      } else if (json["data"] is! List<dynamic>) {
        user = User.fromJson(json["data"]);
      }
    }

    return LoginResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: user,
    );
  }
}




