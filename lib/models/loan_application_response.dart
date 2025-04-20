import 'dart:convert';

import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/response.dart';
import 'package:synpitarn/models/meta.dart';

class LoanApplicationResponse {
  final Response response;
  final Meta meta;
  final Loan data;

  LoanApplicationResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory LoanApplicationResponse.loanApplicationResponseFromJson(String str) => LoanApplicationResponse.fromJson(json.decode(str));

  factory LoanApplicationResponse.fromJson(Map<String, dynamic> json) {
    return LoanApplicationResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: json["data"] is Map<String, dynamic> ? Loan.fromJson(json["data"]) : Loan.defaultLoan(),
    );
  }
}
