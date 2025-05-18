import 'dart:convert';

import 'package:synpitarn/data/language.dart';

class Document {
  int id = 0;
  int userId = 0;
  int clientId = 0;
  int versionId = 0;
  int oldVersionId = 0;
  int loanApplicationId = 0;
  String uniqueId = "";
  String oldUniqueId = "";
  String controlId = "";
  String docType = "";
  String docName = "";
  String name = "";
  String nameEN = "";
  String nameMM = "";
  String nameTH = "";
  String docUrl = "";
  String status = "";
  String type = "";
  String file = "";
  String fileName = "";
  String filePath = "";
  String createdAt = "";
  String updatedAt = "";

  Document.defaultDocument();

  Document({
    required this.id,
    required this.userId,
    required this.clientId,
    required this.versionId,
    required this.oldVersionId,
    required this.loanApplicationId,
    required this.uniqueId,
    required this.oldUniqueId,
    required this.controlId,
    required this.docType,
    required this.docName,
    required this.name,
    required this.nameEN,
    required this.nameMM,
    required this.nameTH,
    required this.docUrl,
    required this.status,
    required this.type,
    required this.file,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      clientId: int.tryParse(json['client_id'].toString()) ?? 0,
      versionId: int.tryParse(json['version_id'].toString()) ?? 0,
      oldVersionId: int.tryParse(json['old_version_id'].toString()) ?? 0,
      loanApplicationId:
          int.tryParse(json['loan_application_id'].toString()) ?? 0,
      uniqueId: json['unique_id'] ?? "",
      oldUniqueId: json['old_unique_id'] ?? "",
      controlId: json['control_id'] ?? "",
      docType: json['doc_type'] ?? "",
      docName: json['doc_name'] ?? "",
      name: json['name'] ?? "",
      nameEN: json['name_en'] ?? "",
      nameMM: json['name_mm'] ?? "",
      nameTH: json['name_th'] ?? "",
      docUrl: json['doc_url'] ?? "",
      status: json['status'].toString(),
      type: json['type'] ?? "",
      file: json['file'] ?? "",
      fileName: json['file_name'] ?? "",
      filePath: json['file_path'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'client_id': clientId,
      'version_id': versionId,
      'old_version_id': oldVersionId,
      'loan_application_id': loanApplicationId,
      'unique_id': uniqueId,
      'old_unique_id': oldUniqueId,
      'control_id': controlId,
      'doc_type': docType,
      'doc_name': docName,
      'name': name,
      'name_en': nameEN,
      'name_mm': nameMM,
      'name_th': nameTH,
      'doc_url': docUrl,
      'status': status,
      'type': type,
      'file': file,
      'file_name': fileName,
      'file_path': filePath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String documentResponseToJson() => json.encode(toJson());

  factory Document.documentResponseToJson(String source) =>
      Document.fromJson(json.decode(source));

  String getName() {
    switch (Language.currentLanguage) {
      case LanguageType.my:
        return nameMM;
      case LanguageType.th:
        return nameTH;
      default:
        return nameEN;
    }
  }
}
