import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/util/call_manager.dart';

@pragma('vm:entry-point') // ✅ Keep this whole class in release mode
class NotificationService {
  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // ✅ Android notification channel for high-priority calls/messages
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'video_call_channel',
    'Video Calls',
    description: 'This channel is used for incoming video calls.',
    importance: Importance.high,
  );

  /// ✅ Main initialization (foreground + background + token)
  static Future<void> initializeFCM() async {
    print("🔧 Initializing FCM...");

    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
      print("✅ FCM permission granted.");

      String? token = await _messaging.getToken();
      print("📲 Current FCM Token: $token");

      if (token != null) {
        await _saveTokenToServer(token);
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        print("🔄 Token refreshed: $newToken");
        await _saveTokenToServer(newToken);
      });

      await _initLocalNotifications();
      print("✅ Local notifications initialized.");

      await _createNotificationChannel();
      print("✅ Notification channel created.");

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen((msg) {
        print("📬 App opened from notification: ${msg.data}");
      });

      print("✅ FCM fully initialized.");
    } catch (e) {
      print("❌ Error in initializeFCM: $e");
    }
  }

  static Future<void> sendTokenIfAvailable() async {
    String? token = await _messaging.getToken();
    if (token != null) {
      await _saveTokenToServer(token);
    } else {
      print("FCM token null");
    }
  }

  /// ✅ Send token to backend
  static Future<bool> _saveTokenToServer(String fcmToken) async {
    final bearerToken = await AuthService.getBearerToken();
    final userId = await getLoginUser();
    final clientId = userId.id.toString();
    final deviceId = await AuthService.getDeviceId();
    print("🔑 FCM token: $fcmToken");
    print("🔑 Client ID: $clientId");
    print("🔑 Device ID: $deviceId");

    if (bearerToken == null || bearerToken.isEmpty) {
      print("❌ No bearer token available. Skipping token sync.");
      return false;
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
        print("✅ Save fcm token successfully to  server!.");
        print('Response===> ${response.body.toString()}');
        return true;
      } else {
        print("❌ Save fcm token fail to Server: ${response.statusCode}");
        print(response.body);
        return false;
      }
    } catch (e) {
      print("❌ Error syncing token: $e");
      return false;
    }
  }

  /// ✅ Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) async {
    print('📩 Foreground FCM message: ${message.data}');
    final data = message.data;

    if (data['type'] == 'video_call') {
      // Show call UI
      await CallManager.showIncomingCall(data);
    } else {
      // Generic message notification
      await showNotification(
        message.notification?.title ?? "Notification",
        message.notification?.body ?? "You have a new message",
      );
    }
  }

  /// ✅ Background / terminated message handler
  /// Called from main.dart top-level function
  @pragma('vm:entry-point')
  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print('📩 Background/Terminated FCM message: ${message.data}');
    final data = message.data;

    if (data['type'] == 'video_call') {
      await CallManager.showIncomingCall(data);
    } else {
      await showNotification(
        message.notification?.title ?? "Notification",
        message.notification?.body ?? "You have a new message",
      );
    }
  }

  /// ✅ Initialize flutter_local_notifications
  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotificationsPlugin.initialize(settings);
  }

  /// ✅ Create Android notification channel
  static Future<void> _createNotificationChannel() async {
    final androidPlugin =
        _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_channel);
      print('✅ Android notification channel created.');
    }
  }

  /// ✅ Show local notification
  @pragma('vm:entry-point') // ✅ Keep in release mode for background calls
  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'video_call_channel', // must match _channel.id
          'Video Calls',
          channelDescription: 'Incoming video calls',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      0, // notification ID
      title,
      body,
      platformDetails,
    );
  }
}
