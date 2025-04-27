import 'package:synpitarn/models/province.dart';

class Branch {
  final int id;
  final String nameEn;
  final String nameTh;
  final String nameMm;
  final String branchCode;
  final int provinceId;
  final String latitude;
  final String longitude;
  final String address;
  final String addressMm;
  final String addressTh;
  final String? phoneNumber;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<String> sections;
  final String phone;
  final String? groupName;
  final Province province;

  Branch({
    required this.id,
    required this.nameEn,
    required this.nameTh,
    required this.nameMm,
    required this.branchCode,
    required this.provinceId,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.addressMm,
    required this.addressTh,
    this.phoneNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.sections,
    required this.phone,
    this.groupName,
    required this.province,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? 0,
      nameEn: json['name_en'] ?? "",
      nameTh: json['name_th'] ?? "",
      nameMm: json['name_mm'] ?? "",
      branchCode: json['branch_code'] ?? "",
      provinceId: json['province_id'] ?? 0,
      latitude: json['latitude'] ?? "",
      longitude: json['longitude'] ?? "",
      address: json['address'] ?? "",
      addressMm: json['address_mm'] ?? "",
      addressTh: json['address_th'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      status: json['status'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      sections: List<String>.from(json['sections']),
      phone: json['phone'] ?? "",
      groupName: json['group_name'] ?? "",
      province: Province.fromJson(json['province']),
    );
  }
}