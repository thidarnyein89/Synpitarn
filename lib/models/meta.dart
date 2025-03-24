class Meta {
  final dynamic hasNextPage;
  final int count;
  final int perPage;
  final int total;
  final String message;

  Meta({
    required this.hasNextPage,
    required this.count,
    required this.perPage,
    required this.total,
    required this.message,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    hasNextPage: json["has_next_page"],
    count: json["count"],
    perPage: json["per_page"],
    total: json["total"],
    message: json["message"] ?? "",
  );
}