import 'dart:convert';
import 'package:synpitarn/models/user.dart';
import 'response.dart';
import 'meta.dart';

class UserResponse {
  final Response response;
  final Meta meta;
  final User data;

  UserResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory UserResponse.userResponseFromJson(String str) =>
      UserResponse.fromJson(json.decode(str));

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    User user = User.defaultUser();

    if (json.containsKey("data")) {
      if (json["data"] is int) {
        user.code = json["data"].toString();
      } else if (json["data"] is! List<dynamic>) {
        user = User.fromJson(json["data"]);
      }
    }

    return UserResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: user,
    );
  }
}
