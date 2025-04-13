import 'dart:convert';

import 'package:synpitarn/models/document.dart';
import 'response.dart';
import 'meta.dart';

class DocumentResponse {
  final Response response;
  final Meta meta;
  final Document data;

  DocumentResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory DocumentResponse.documentResponseFromJson(String str) =>
      DocumentResponse.fromJson(json.decode(str));

  factory DocumentResponse.fromJson(Map<String, dynamic> json) {
    Document document = Document.defaultDocument();
    if (json.containsKey("data") && json["data"] is! List<dynamic>) {
      document = Document.fromJson(json["data"]);
    }

    return DocumentResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: document,
    );
  }
}
