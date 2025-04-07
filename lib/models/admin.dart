import 'dart:convert';

import 'response.dart';
import 'meta.dart';

class Admin {
  int id = 0;
  String name = '';
  String? email = '';
  String? emailVerifiedAt = '';
  int branchId = 0;
  String? nationality = '';
  String? userType = '';
  String? branch = '';
  String? role = '';
  String? createdAt = '';
  String? updatedAt = '';
  String? deletedAt = '';
  bool isReport = false;
  String? photoUrl = '';

  Admin.defaultAdmin();

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.branchId,
    required this.nationality,
    required this.userType,
    required this.branch,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.isReport,
    required this.photoUrl
  });

  factory Admin.adminResponseFromJson(String str) => Admin.fromJson(json.decode(str));

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        emailVerifiedAt: json['email_verified_at'] ?? "",
        branchId: json['branch_id'] ?? 0,
        nationality: json['nationality'] ?? "",
        userType: json['user_type'] ?? "",
        branch: json['branch'] ?? "",
        role: json['role'] ?? "",
        createdAt: json['created_at'] ?? "",
        updatedAt: json['updated_at'] ?? "",
        deletedAt: json['deleted_at'] ?? "",
        isReport: json.containsKey("is_report") ? json["is_report"] is bool ? json["is_report"] : false : false,
        photoUrl: json['photo_url'] ?? ""
    );
  }
}
