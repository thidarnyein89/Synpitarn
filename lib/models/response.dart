class Response {
  final int code;
  final String status;
  final String message;

  Response({
    required this.code,
    required this.status,
    required this.message,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    code: json["code"],
    status: json["status"],
    message: json["message"],
  );
}