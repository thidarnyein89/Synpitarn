import 'dart:convert';

import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/response.dart';
import 'package:synpitarn/models/meta.dart';

class LoanResponse {
  final Response response;
  final Meta meta;
  final List<Loan> data;

  LoanResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory LoanResponse.loanResponseFromJson(String str) =>
      LoanResponse.fromJson(json.decode(str));

  factory LoanResponse.fromJson(Map<String, dynamic> json) {
    List<Loan> loanList = [];

    final loanJson = json['data'] ?? [];
    if (loanJson is List) {
      for (final loanMap in loanJson) {
        if (loanMap is Map<String, dynamic>) {
          loanList.add(Loan.fromJson(loanMap));
        }
      }
    }

    return LoanResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: loanList,
    );
  }
}
