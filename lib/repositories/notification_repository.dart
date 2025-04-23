import 'package:http/http.dart' as http;
import 'package:synpitarn/models/notification_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/app_config.dart';

class NotificationRepository {
  // Future<NotificationResponse> getNotificationCount(User loginRequest) async {
  //   String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/count/notification");

  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer ${loginRequest.token}",
  //       "x-user-id": loginRequest.id.toString(),
  //     },
  //   );

  //   return NotificationResponse.notificationResponseFromJson(response.body);
  // }

  Future<NotificationResponse> getNotificationLists(User loginRequest) async {
    String url =
        ("${AppConfig.BASE_URL}/${AppConfig.PATH}/notification?page=1");

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

  // Future<List<NotificationModel>> fetchNotifications(User loginRequest) async {
  //   String url =
  //       ("${AppConfig.BASE_URL}/${AppConfig.PATH}/notification?page=1");

  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer ${loginRequest.token}",
  //       "x-user-id": loginRequest.id.toString(),
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     final List<dynamic> jsonList = json['data'];
  //     final notifications =
  //         jsonList.map((item) => NotificationModel.fromJson(item)).toList();
  //     return notifications;
  //   } else {
  //     throw Exception('Failed to load notifications');
  //   }
  // }
}
