class Province {
  final int id;
  final String nameEn;
  final String nameTh;
  final String nameMm;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String serviceAvailable;

  Province({
    required this.id,
    required this.nameEn,
    required this.nameTh,
    required this.nameMm,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceAvailable,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      nameEn: json['name_en'],
      nameTh: json['name_th'],
      nameMm: json['name_mm'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      serviceAvailable: json['service_available'],
    );
  }
}