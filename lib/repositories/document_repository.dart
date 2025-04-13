import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/document.dart';
import 'package:synpitarn/models/document_response.dart';
import 'package:synpitarn/models/image_file.dart';
import 'package:synpitarn/models/loan_application.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/app_config.dart';

class DocumentRepository {
  Future<DocumentResponse> uploadDocument(
      String randomId, File file, User loginUser) async {
    String url =
        ("${AppConfig.BASE_URL}/${AppConfig.PATH}/form/type/default/upload-file");

    var request = http.MultipartRequest("POST", Uri.parse(url))
      ..headers.addAll({
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      })
      ..fields['version_id'] = AppConfig.VERSION_ID.toString()
      ..fields['unique_id'] = randomId
      ..files.add(await http.MultipartFile.fromPath(
        'document',
        file.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return DocumentResponse.documentResponseFromJson(response.body);
  }

  Future<DocumentResponse> deleteDocument(
      ImageFile imageFile, User loginUser) async {
    var post_body = {
      "id": imageFile.id,
      "unique_id": imageFile.uniqueId,
      "version_id": AppConfig.VERSION_ID,
    };

    String url =
        ("${AppConfig.BASE_URL}/${AppConfig.PATH}/form/type/default/delete");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(post_body),
    );

    return DocumentResponse.documentResponseFromJson(response.body);
  }

  Future<DocumentResponse> saveDocumentStep(
      DefaultData defaultData, User loginUser) async {
    var post_body = {
      "version_id": AppConfig.VERSION_ID,
      "input_data": defaultData.inputData
    };

    String url =
        ("${AppConfig.BASE_URL}/${AppConfig.PATH}/form/type/default/step/required_documents");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(post_body),
    );

    return DocumentResponse.documentResponseFromJson(response.body);
  }
}
