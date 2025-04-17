import 'dart:convert';

class Document {
  int id = 0;
  int clientId = 0;
  int versionId = 0;
  int oldVersionId = 0;
  String uniqueId = "";
  String oldUniqueId = "";
  String docType = "";
  String docName = "";
  String docUrl = "";
  String status = "";
  String type = "";
  String createdAt = "";
  String updatedAt = "";

  Document.defaultDocument();

  Document(
      {required this.id,
      required this.clientId,
      required this.versionId,
      required this.oldVersionId,
      required this.uniqueId,
      required this.oldUniqueId,
      required this.docType,
      required this.docName,
      required this.docUrl,
      required this.status,
      required this.type,
      required this.createdAt,
      required this.updatedAt});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] ?? 0,
      clientId: int.tryParse(json['client_id'].toString()) ?? 0,
      versionId: int.tryParse(json['version_id'].toString()) ?? 0,
      oldVersionId: int.tryParse(json['old_version_id'].toString()) ?? 0,
      uniqueId: json['unique_id'] ?? "",
      oldUniqueId: json['old_unique_id'] ?? "",
      docType: json['doc_type'] ?? "",
      docName: json['doc_name'] ?? "",
      docUrl: json['doc_url'] ?? "",
      status: json['status'] ?? "",
      type: json['type'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'version_id': versionId,
      'old_version_id': oldVersionId,
      'unique_id': uniqueId,
      'old_unique_id': oldUniqueId,
      'doc_type': docType,
      'doc_name': docName,
      'doc_url': docUrl,
      'status': status,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }

  String documentResponseToJson() => json.encode(toJson());

  factory Document.documentResponseToJson(String source) =>
      Document.fromJson(json.decode(source));
}
