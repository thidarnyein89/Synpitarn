import 'dart:convert';

class Document {
  int id = 0;
  String clientId = "";
  String versionId = "";
  String oldVersionId = "";
  String uniqueId = "";
  String oldUniqueId = "";
  String docType = "";
  String docName = "";
  String docPath = "";
  String status = "";
  String type = "";
  String createdAt = "";
  String updatedAt = "";
  String inputData = "";
  String loanApplicationId = "";
  String loanTypeId = "";
  String oldInputData = "";
  String timesPerMonth = "";
  String workPermitUrl = "";

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
      required this.docPath,
      required this.status,
      required this.type,
      required this.createdAt,
      required this.updatedAt,
      required this.inputData,
      required this.loanApplicationId,
      required this.loanTypeId,
      required this.oldInputData,
      required this.timesPerMonth,
      required this.workPermitUrl});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
        id: json['id'] ?? 0,
        clientId: json['client_id'] ?? "",
        versionId: json['version_id'] ?? "",
        oldVersionId: json['old_version_id'] ?? "",
        uniqueId: json['unique_id'] ?? "",
        oldUniqueId: json['old_unique_id'] ?? "",
        docType: json['doc_type'] ?? "",
        docName: json['doc_name'] ?? "",
        docPath: json['doc_path'] ?? "",
        status: json['status'] ?? "",
        type: json['type'] ?? "",
        createdAt: json['created_at'] ?? "",
        updatedAt: json['updated_at'] ?? "",
        inputData: json['input_data'] ?? "",
        loanApplicationId: json['loan_application_id'] ?? "",
        loanTypeId: json['loan_type_id'] ?? "",
        oldInputData: json['old_input_data'] ?? "",
        timesPerMonth: json['times_per_month'] ?? "",
        workPermitUrl: json['work_permit_url'] ?? "");
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
      'doc_path': docPath,
      'status': status,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'input_data': inputData,
      'loan_application_id': loanApplicationId,
      'loan_type_id': loanTypeId,
      'old_input_data': oldInputData,
      'times_per_month': timesPerMonth,
      'work_permit_url': workPermitUrl
    };
  }

  String documentResponseToJson() => json.encode(toJson());

  factory Document.documentResponseToJson(String source) =>
      Document.fromJson(json.decode(source));
}
