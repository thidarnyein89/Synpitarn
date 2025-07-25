import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/local_storage.dart';
import 'package:synpitarn/util/call_manager.dart'; // Optional

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
        'call_channel',
        'Calls',
        importance: Importance.high,
        playSound: true,
      );

  static String? _lastToken;

  static Future<void> initializeFCM() async {
    final messaging = FirebaseMessaging.instance;

    // ✅ Initialize local notifications
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationClick(details.payload);
      },
    );

    // ✅ Android channel
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_defaultChannel);

    // ✅ Request permission
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // ✅ Foreground handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = message.data;
      print('📬 Received message: ${data.toString()}');

      if (data['type'] == 'video_call') {
        CallManager.showIncomingCall(data); // ✅ Updated class
      } else {
        _showLocalNotification(
          title: message.notification?.title ?? data['title'] ?? 'Notification',
          body: message.notification?.body ?? data['body'] ?? '',
          payload: jsonEncode(data),
        );
      }
    });

    // ✅ Tap when app opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final data = message.data;
      print('📬 Message opened from background: ${data.toString()}');

      if (data['type'] == 'video_call') {
        CallManager.showIncomingCall(data);
      }
    });

    // ✅ Get current token
    final currentToken = await messaging.getToken();
    final localToken = await LocalStorage.getSavedToken();
    print('Current FCM Token: $currentToken');
    if (currentToken != null && currentToken != localToken) {
      final success = await _saveTokenToServer(currentToken);
      if (success) {
        await LocalStorage.saveToken(currentToken);
      }
    }

    // 🔁 Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final localToken = await LocalStorage.getSavedToken();
      if (newToken != localToken) {
        final success = await _saveTokenToServer(newToken);
        if (success) {
          await LocalStorage.saveToken(newToken);
        }
      }
    });
  }

  static Future<bool> _saveTokenToServer(String fcmToken) async {
    final bearerToken = await AuthService.getBearerToken();
    final userId = await getLoginUser();
    final clientId = userId.id.toString(); // Assuming user ID is the client ID
    final deviceId = await AuthService.getDeviceId();
    print('Bearer Token: $bearerToken');
    print('Client ID: $clientId');
    print('Device ID: $deviceId');

    if (bearerToken == null || bearerToken.isEmpty) {
      print("❌ No bearer token available.");
      return false; // ⬅ return false here
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
          'client_id': clientId,
          'fcm_token': fcmToken,
          'device_id': deviceId,
        },
      );

      if (response.statusCode == 200) {
        print("✅ Token synced with server.");
        return true; // ⬅ success
      } else {
        print("❌ Failed to sync token: ${response.statusCode}");
        print(response.body);
        return false; // ⬅ failed
      }
    } catch (e) {
      print("❌ Error syncing token: $e");
      return false; // ⬅ on exception
    }
  }

  static void _handleNotificationClick(String? payload) {
    if (payload == null) return;

    try {
      final data = jsonDecode(payload);

      if (data['type'] == 'video_call') {
        CallManager.showIncomingCall(data);
      } else {
        print('📥 Unknown notification type, no action.');
      }
    } catch (e) {
      print('❌ Error parsing notification payload: $e');
    }
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _defaultChannel.id,
          _defaultChannel.name,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }
}
