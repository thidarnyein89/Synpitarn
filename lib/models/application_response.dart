import 'dart:convert';

import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/models/admin.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/response.dart';
import 'package:synpitarn/models/meta.dart';

class ApplicationResponse {
  final Response response;
  final Meta meta;
  final Loan data;

  ApplicationResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory ApplicationResponse.applicationResponseFromJson(String str) => ApplicationResponse.fromJson(json.decode(str));

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: json["data"] is Map<String, dynamic> ? Loan.fromJson(json["data"]) : Loan.defaultLoan(User.defaultUser(), Admin.defaultAdmin()),
    );
  }
}
