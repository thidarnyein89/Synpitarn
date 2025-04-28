import 'dart:convert';

class Document {
  int id = 0;
  int userId = 0;
  int clientId = 0;
  int versionId = 0;
  int oldVersionId = 0;
  int loanApplicationId = 0;
  String uniqueId = "";
  String oldUniqueId = "";
  String docType = "";
  String docName = "";
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
    required this.docType,
    required this.docName,
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
      docType: json['doc_type'] ?? "",
      docName: json['doc_name'] ?? "",
      docUrl: json['doc_url'] ?? "",
      status: json['status'] ?? "",
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
      'doc_type': docType,
      'doc_name': docName,
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
}
