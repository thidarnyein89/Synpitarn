import 'dart:convert';
import 'package:synpitarn/models/notification.dart';

import 'response.dart';
import 'meta.dart';

class NotificationResponse {
  final Response response;
  final Meta meta;
  final dynamic data;

  NotificationResponse({
    required this.response,
    required this.meta,
    required this.data,
  });

  factory NotificationResponse.notificationResponseFromJson(String str) =>
      NotificationResponse.fromJson(json.decode(str));

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    List<NotificationModel> notificationList = [];

    final loanJson = json['data'] ?? [];
    if (loanJson is List) {
      for (final loanMap in loanJson) {
        if (loanMap is Map<String, dynamic>) {
          notificationList.add(NotificationModel.fromJson(loanMap));
        }
      }
    }

    return NotificationResponse(
        response: Response.fromJson(json["response"]),
        meta: Meta.fromJson(json["meta"]),
        data: (loanJson is List)
            ? (json['data'] as List)
                .map((e) => NotificationModel.fromJson(e))
                .toList()
            : json['data']);
  }
}
