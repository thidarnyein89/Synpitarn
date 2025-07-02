import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/util/call_manager.dart';

class NotificationService {
  static Future<void> initializeFCM({required String clientId}) async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundClick);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) _handleBackgroundClick(initialMessage);

    final token = await FirebaseMessaging.instance.getToken();
    print('FCM Token====> $token');
    if (token != null) {
      await _saveTokenToServer(clientId, token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _saveTokenToServer(clientId, newToken);
    });
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    print("📲 Foreground FCM received: $data");

    if (data['type'] == 'video_call') {
      CallManager.showIncomingCall(data);
    }
  }

  static void _handleBackgroundClick(RemoteMessage message) {
    final data = message.data;
    print("📲 Notification clicked (background): $data");

    if (data['type'] == 'video_call') {
      CallManager.startAgoraCall(data);
    }
  }

  static Future<void> _saveTokenToServer(
    String clientId,
    String fcmToken,
  ) async {
    final bearerToken = await AuthService.getBearerToken();
    if (bearerToken == null) {
      print("❌ Cannot save token without access token");
      return;
    }

    final url = Uri.parse('https://report.synpitarn.com/api/v1/fcm-token');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'client_id': clientId, 'fcm_token': fcmToken},
    );

    if (response.statusCode == 200) {
      print("✅ Token saved");
    } else {
      print("❌ Failed to save token: ${response.statusCode}");
      print(response.body);
    }
  }
}
