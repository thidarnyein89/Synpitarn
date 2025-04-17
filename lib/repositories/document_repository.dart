import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:synpitarn/models/document_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/app_config.dart';

class DocumentRepository {
  Future<DocumentResponse> uploadDocument(Map<String, dynamic> postBody, User loginUser) async {
    String url =
        ("${AppConfig.BASE_URL}/${AppConfig.PATH}/form/type/default/upload-file");

    var request = http.MultipartRequest("POST", Uri.parse(url))
      ..headers.addAll({
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      })
      ..fields['version_id'] = postBody['version_id'].toString()
      ..fields['unique_id'] = postBody['unique_id']
      ..files.add(await http.MultipartFile.fromPath(
        'document',
        postBody['file_path'],
        contentType: MediaType('image', 'jpeg'),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return DocumentResponse.documentResponseFromJson(response.body);
  }

  Future<DocumentResponse> deleteDocument(Map<String, dynamic> postBody, User loginUser) async {

    String url =
        ("${AppConfig.BASE_URL}/${AppConfig.PATH}/form/type/default/delete");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(postBody),
    );

    return DocumentResponse.documentResponseFromJson(response.body);
  }

  Future<DocumentResponse> getUploadDocumentData(User loginRequest, int versionId) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/form/type/default/upload-file?version_id=$versionId");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginRequest.token}",
        "x-user-id": loginRequest.id.toString(),
      },
    );

    return DocumentResponse.documentResponseFromJson(response.body);
  }
}
