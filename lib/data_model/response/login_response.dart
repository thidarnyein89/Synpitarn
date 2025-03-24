import 'dart:convert';

import 'response.dart';
import 'meta.dart';

class LoginResponse {
  final Response response;
  final Meta meta;
  final List<dynamic> data;

  LoginResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    response: Response.fromMap(json["response"]),
    meta: Meta.fromMap(json["meta"]),
    data: List<dynamic>.from(json["data"] ?? []),
  );
}
