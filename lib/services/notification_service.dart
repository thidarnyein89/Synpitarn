import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/local_storage.dart';
import 'package:synpitarn/util/call_manager.dart';

@pragma('vm:entry-point') // ✅ Keep this whole class in release mode
class NotificationService {
  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // ✅ Android notification channel for high-priority calls/messages
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'video_call_channel',
    'Video Calls',
    description: 'This channel is used for incoming video calls.',
    importance: Importance.high,
  );

  /// ✅ Main initialization (foreground + background + token)
  static Future<void> initializeFCM() async {
    final messaging = FirebaseMessaging.instance;

    // ✅ Request permission (iOS shows dialog)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // ✅ Local Notification init
    await _initLocalNotifications();

    // ✅ Create Android notification channel
    await _createNotificationChannel();

    // ✅ Sync FCM token to server
    await _syncFCMToken(messaging);

    // ✅ Foreground message listener
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // ✅ Background handler is registered in main.dart (onBackgroundMessage)
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

  /// ✅ Sync token with API server
  static Future<void> _syncFCMToken(FirebaseMessaging messaging) async {
    final currentToken = await messaging.getToken();
    final localToken = await LocalStorage.getSavedToken();

    print('📲 Current FCM Token: $currentToken');

    if (currentToken != null && currentToken != localToken) {
      final success = await _saveTokenToServer(currentToken);
      if (success) {
        await LocalStorage.saveToken(currentToken);
      }
    }

    // ✅ Token refresh listener
    messaging.onTokenRefresh.listen((newToken) async {
      final oldToken = await LocalStorage.getSavedToken();
      if (newToken != oldToken) {
        final success = await _saveTokenToServer(newToken);
        if (success) {
          await LocalStorage.saveToken(newToken);
        }
      }
    });
  }

  /// ✅ Send token to backend
  static Future<bool> _saveTokenToServer(String fcmToken) async {
    final bearerToken = await AuthService.getBearerToken();
    final userId = await getLoginUser();
    final clientId = userId.id.toString();
    final deviceId = await AuthService.getDeviceId();

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
        print("✅ FCM token synced with server.");
        return true;
      } else {
        print("❌ Failed to sync token: ${response.statusCode}");
        print(response.body);
        return false;
      }
    } catch (e) {
      print("❌ Error syncing token: $e");
      return false;
    }
  }
}
