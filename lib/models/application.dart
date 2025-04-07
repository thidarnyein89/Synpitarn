import 'dart:convert';

import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/models/admin.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/response.dart';
import 'package:synpitarn/models/meta.dart';

class Application {
  final Response response;
  final Meta meta;
  final Loan data;

  Application({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory Application.applicationResponseFromJson(String str) => Application.fromJson(json.decode(str));

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: json["data"] is Map<String, dynamic> ? Loan.fromJson(json["data"]) : new Loan.defaultLoan(new User.defaultUser(), new Admin.defaultAdmin()),
    );
  }
}
