import 'dart:convert';

import 'package:synpitarn/models/user.dart';

import 'response.dart';
import 'meta.dart';

class Login {
  final Response response;
  final Meta meta;
  final User data;

  Login({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory Login.loginResponseFromJson(String str) => Login.fromJson(json.decode(str));

  factory Login.fromJson(Map<String, dynamic> json) {
    var userData = json["data"];

    if(json["data"] is Map<String, dynamic>) {
      return Login(
        response: Response.fromJson(json["response"]),
        meta: Meta.fromJson(json["meta"]),
        data: User.fromJson(userData),
      );
    }
    else {
      return Login(
        response: Response.fromJson(json["response"]),
        meta: Meta.fromJson(json["meta"]),
        data: new User.defaultUser(),
      );
    }
  }
}
