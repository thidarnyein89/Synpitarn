import 'dart:convert';

import 'response.dart';
import 'meta.dart';

class OTP {
  final Response response;
  final Meta meta;
  final String data;

  OTP({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory OTP.otpResponseFromJson(String str) => OTP.fromJson(json.decode(str));

  factory OTP.fromJson(Map<String, dynamic> json) {

    if(json["data"] is int) {
      return OTP(
        response: Response.fromJson(json["response"]),
        meta: Meta.fromJson(json["meta"]),
        data: json["data"].toString(),
      );
    }
    else {
      return OTP(
        response: Response.fromJson(json["response"]),
        meta: Meta.fromJson(json["meta"]),
        data: "",
      );
    }
  }
}
