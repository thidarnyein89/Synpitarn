import 'dart:convert';

import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/response.dart';
import 'package:synpitarn/models/meta.dart';

class DataResponse {
  final Response response;
  final Meta meta;
  final List<dynamic> data;

  DataResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory DataResponse.dataResponseFromJson(String str) =>
      DataResponse.fromJson(json.decode(str));

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: json["data"] is List
          ? json["data"]
              .map((item) {
                if (item is String) {
                  return item;
                } else if (item is Map<String, dynamic>) {
                  return Data.fromJson(item);
                }
                return null;
              })
              .where((item) => item != null)
              .toList()
          : [],
    );
  }
}
