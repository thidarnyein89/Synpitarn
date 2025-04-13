import 'dart:convert';
import 'response.dart';
import 'meta.dart';

class NotificationResponse {
  final Response response;
  final Meta meta;
  final int data;

  NotificationResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory NotificationResponse.notificationResponseFromJson(String str) => NotificationResponse.fromJson(json.decode(str));

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: json["data"] is int ? json["data"] : 0,
    );
  }
}
