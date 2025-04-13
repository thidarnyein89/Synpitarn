import 'dart:convert';
import 'package:synpitarn/models/user.dart';

class WorkPermitResponse {
  final User client;
  final String message;

  WorkPermitResponse({
    required this.client,
    required this.message,
  });

  factory WorkPermitResponse.workPermitResponseFromJson(String str){
    return  WorkPermitResponse.fromJson(json.decode(str));
  }


  factory WorkPermitResponse.fromJson(Map<String, dynamic> json) {
    return WorkPermitResponse(
      client: json.containsKey("client") && json["client"] is Map<String, dynamic>
          ? User.fromJson(json["client"])
          : User.defaultUser(),
      message: json["message"] ?? "",
    );
  }
}
