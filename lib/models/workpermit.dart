import 'dart:convert';
import 'package:synpitarn/models/user.dart';
import 'response.dart';
import 'meta.dart';

class Workpermit {
  final User client;
  final String message;

  Workpermit({
    required this.client,
    required this.message,
  });

  factory Workpermit.workpermitResponseFromJson(String str){
    return  Workpermit.fromJson(json.decode(str));
  }


  factory Workpermit.fromJson(Map<String, dynamic> json) {
    return Workpermit(
      client: json.containsKey("client") && json["client"] is Map<String, dynamic>
          ? User.fromJson(json["client"])
          : new User.defaultUser(),
      message: json["message"] ?? "",
    );
  }
}
