import 'dart:convert';
import 'response.dart';
import 'meta.dart';

class Notification {
  final Response response;
  final Meta meta;
  final int data;

  Notification({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory Notification.notificationResponseFromJson(String str) => Notification.fromJson(json.decode(str));

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      response: Response.fromJson(json["response"]),
      meta: Meta.fromJson(json["meta"]),
      data: json["data"] is int ? json["data"] : 0,
    );
  }
}
