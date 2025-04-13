import 'dart:convert';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/document.dart';
import 'package:synpitarn/models/meta.dart';
import 'package:synpitarn/models/response.dart';

class DefaultResponse {
  final Response response;
  final Meta meta;
  final DefaultData data;

  DefaultResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory DefaultResponse.defaultResponseFromJson(String str) =>
      DefaultResponse.fromJson(json.decode(str));

  factory DefaultResponse.fromJson(Map<String, dynamic> json) {
    DefaultData data =
        DefaultData.defaultDefaultData();

    if (json.containsKey("data") && json["data"] is! List<dynamic>) {
      data = DefaultData.fromJson(json["data"]);
    }

    return DefaultResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: data,
    );
  }
}
