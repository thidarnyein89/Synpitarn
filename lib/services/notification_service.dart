import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/util/call_manager.dart';

class NotificationService {
  static String? _lastToken;

  static Future<void> initializeFCM() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundClick);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) _handleBackgroundClick(initialMessage);

    final deviceId = await AuthService.getDeviceId();
    final token = await FirebaseMessaging.instance.getToken();
    final userId = await getLoginUser();

    print('FCM Token====> $token');
    print('User Id====> ${userId.id}');
    print('Device Id====> $deviceId');

    if (token != null && token != _lastToken) {
      _lastToken = token;
      await _saveTokenToServer(userId.id, token, deviceId!);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (newToken != _lastToken) {
        _lastToken = newToken;
        _saveTokenToServer(userId.id, newToken, deviceId!);
      }
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
    int clientId,
    String fcmToken,
    String deviceId,
  ) async {
    final bearerToken = await AuthService.getBearerToken();
    if (bearerToken == null) {
      print("❌ Cannot save token without access token");
      return;
    }

    final url = Uri.parse('http://13.213.165.89/api/v1/fcm-token');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': clientId.toString(),
        'fcm_token': fcmToken,
        'device_id': deviceId,
      },
    );

    if (response.statusCode == 200) {
      print("✅ Token saved");
    } else {
      print("❌ Failed to save token: ${response.statusCode}");
      print(response.body);
    }
  }
}
