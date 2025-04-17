import 'dart:convert';

import 'package:synpitarn/models/document.dart';
import 'response.dart';
import 'meta.dart';

class DocumentResponse {
  final Response response;
  final Meta meta;
  final List<Document> data;

  DocumentResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory DocumentResponse.documentResponseFromJson(String str) =>
      DocumentResponse.fromJson(json.decode(str));

  factory DocumentResponse.fromJson(Map<String, dynamic> json) {
    List<Document> documentList = [];

    if (json['data'] != null) {
      if(json['data'] is List) {
        for (var data in json['data']) {
          documentList.add(Document.fromJson(data));
        }
      }
      else {
        documentList.add(Document.fromJson(json["data"]));
      }
    }

    return DocumentResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: documentList,
    );
  }
}
