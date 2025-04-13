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
    User user = User.defaultUser();
    if(json.containsKey("data") && json["data"] is! List<dynamic>) {
      user = User.fromJson(json["data"]);
    }

    return Login(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: user,
    );
  }
}




