import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/main.dart';
import 'package:synpitarn/screens/notification/notification_screen.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/util/call_manager.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
        'call_channel', // 🔔 Must match android_channel_id from FCM payload
        'Calls',
        importance: Importance.high,
        playSound: true,
      );

  static String? _lastToken;

  static Future<void> initializeFCM() async {
    final messaging = FirebaseMessaging.instance;

    // ✅ Local Notification Initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationClick(details.payload);
      },
    );

    // ✅ Create notification channel (required for Android 8+)
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_defaultChannel);

    // ✅ Request permissions
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // ✅ Foreground notifications
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // ✅ Background notification tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundClick);

    // ✅ App launched from terminated state via notification
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundClick(initialMessage);
    }

    // ✅ Sync FCM token
    await _handleAndSyncToken();

    // ✅ Handle token refresh
    messaging.onTokenRefresh.listen((newToken) async {
      await _handleAndSyncToken(forceRefreshToken: newToken);
    });
  }

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

  /// ✅ Handle Foreground Push
  static void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    print('🔔 Foreground Push: ${message.toMap()}');

    // if (data['type'] == 'call') {
    //   CallManager.showIncomingCall(data);
    // } else {
    //   _showLocalNotification(
    //     title: message.notification?.title ?? data['title'] ?? 'Notification',
    //     body: message.notification?.body ?? data['body'] ?? '',
    //     payload: jsonEncode(data),
    //   );
    // }
    CallManager.showIncomingCall(data);
  }

  /// ✅ Handle Notification Tap in Background or Terminated
  static void _handleBackgroundClick(RemoteMessage message) {
    final data = message.data;
    final context = navigatorKey.currentContext;
    // print('📨 Notification Tap: ${message.toMap()}');

    // if (data['type'] == 'call') {
    //   CallManager.showIncomingCall(data);
    // } else {
    //   // handle other types or navigation if needed
    // }
    if (context == null) {
      Navigator.of(
        context!,
      ).push(MaterialPageRoute(builder: (_) => NotificationScreen()));
    }
  }

  /// ✅ Handle Notification Tap from Foreground Local Notification
  static void _handleNotificationClick(String? payload) {
    if (payload == null) return;
    final data = jsonDecode(payload);
    print('📥 Foreground Notification Click: $data');

    if (data['type'] == 'call') {
      CallManager.showIncomingCall(data);
    } else {
      // handle other types or navigation
      _showLocalNotification(
        title: data.notification?.title ?? data['title'] ?? 'Notification',
        body: data.notification?.body ?? data['body'] ?? '',
        payload: jsonEncode(data),
      );
    }
  }

  /// ✅ Show fallback local notification (used in foreground)
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
