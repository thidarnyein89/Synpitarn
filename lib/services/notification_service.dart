import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/util/call_manager.dart';

class NotificationService {
  static String? _lastToken;

  static Future<void> initializeFCM() async {
    final messaging = FirebaseMessaging.instance;

    // Request Permission
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundClick);

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) _handleBackgroundClick(initialMessage);

    await _handleAndSyncToken();

    messaging.onTokenRefresh.listen((newToken) async {
      await _handleAndSyncToken(forceRefreshToken: newToken);
    });
  }

  //Save refresh token to backend
  static Future<void> _handleAndSyncToken({String? forceRefreshToken}) async {
    final userId = await getLoginUser();
    final deviceId = await AuthService.getDeviceId();
    final token =
        forceRefreshToken ?? await FirebaseMessaging.instance.getToken();

    if (token == null || deviceId == null) {
      print('❌ Token or device ID is null, skipping sync.');
      return;
    }

    print('🔑 FCM Token: $token');
    print('👤 User ID: ${userId.id}');
    print('📱 Device ID: $deviceId');

    if (token != _lastToken) {
      _lastToken = token;
      await _saveTokenToServer(userId.id, token, deviceId);
    }
  }

  // Show foreground message
  static void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    print("📲 Foreground FCM received:\n${jsonEncode(data)}");

    if (data['type'] == 'video_call') {
      CallManager.showIncomingCall(data);
    }
  }

  // Show background message
  static void _handleBackgroundClick(RemoteMessage message) {
    final data = message.data;
    print(
      "📲 Notification clicked (background/terminated):\n${jsonEncode(data)}",
    );

    if (data['type'] == 'video_call') {
      CallManager.startAgoraCall(data);
    }
  }

  //Save token to backend
  static Future<void> _saveTokenToServer(
    int clientId,
    String fcmToken,
    String deviceId,
  ) async {
    final bearerToken = await AuthService.getBearerToken();
    if (bearerToken == null) {
      print("❌ No bearer token available. Cannot sync FCM token.");
      return;
    }

    final url = Uri.parse('http://13.213.165.89/api/v1/fcm-token');

    try {
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
        print("✅ Token synced with server.");
      } else {
        print("❌ Failed to sync token: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("❌ Network error while syncing token: $e");
    }
  }
}
