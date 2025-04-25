import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synpitarn/models/notification_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/app_config.dart';

class NotificationRepository {
  Future<NotificationResponse> getNotificationCount(User loginRequest) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/count/notification");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginRequest.token}",
        "x-user-id": loginRequest.id.toString(),
      },
    );

    return NotificationResponse.notificationResponseFromJson(response.body);
  }

  Future<NotificationResponse> getNotificationLists({
    required User loginRequest,
    required int page,
    int perPage = 10,
  }) async {
    String url =
        ("${AppConfig.BASE_URL}/${AppConfig.PATH}/notification?page=$page");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginRequest.token}",
        "x-user-id": loginRequest.id.toString(),
      },
    );

    return NotificationResponse.notificationResponseFromJson(response.body);
  }

  Future<NotificationResponse> readNotification(
    Map<String, dynamic> postBody,
    User loginUser,
  ) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/notification/read");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginUser.token}",
        "x-user-id": loginUser.id.toString(),
      },
      body: jsonEncode(postBody),
    );

    return NotificationResponse.notificationResponseFromJson(response.body);
  }
}
