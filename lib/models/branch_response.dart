import 'dart:convert';

import 'package:synpitarn/models/branch.dart';
import 'package:synpitarn/models/response.dart';
import 'package:synpitarn/models/meta.dart';

class BranchResponse {
  final Response response;
  final Meta meta;
  final List<Branch> data;

  BranchResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory BranchResponse.branchResponseFromJson(String str) =>
      BranchResponse.fromJson(json.decode(str));

  factory BranchResponse.fromJson(Map<String, dynamic> json) {
    List<Branch> branchList = [];

    if (json['data'] != null) {
      if(json['data'] is List) {
        for (var data in json['data']) {
          branchList.add(Branch.fromJson(data));
        }
      }
      else {
        branchList.add(Branch.fromJson(json["data"]));
      }
    }

    return BranchResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: branchList
    );
  }
}
