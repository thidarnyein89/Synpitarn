import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/local_storage.dart';
import 'package:synpitarn/util/call_manager.dart'; // Optional

class NotificationService {
  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // ✅ Define Android Notification Channel
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'video_call_channel', // Must match with showNotification()
    'Video Calls',
    description: 'This channel is used for incoming video calls.',
    importance: Importance.high,
  );

  /// Main entry to initialize FCM
  static Future<void> initializeFCM() async {
    final messaging = FirebaseMessaging.instance;

    // ✅ Request permission
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // ✅ Create notification channel for Android
    await _createNotificationChannel();

    // ✅ Local Notification Init
    await _initLocalNotifications();

    // ✅ Get and sync FCM token
    final currentToken = await messaging.getToken();
    final localToken = await LocalStorage.getSavedToken();
    print('📲 Current FCM Token: $currentToken');

    if (currentToken != null && currentToken != localToken) {
      final success = await _saveTokenToServer(currentToken);
      if (success) {
        await LocalStorage.saveToken(currentToken);
      }
    }

    // ✅ Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final oldToken = await LocalStorage.getSavedToken();
      if (newToken != oldToken) {
        final success = await _saveTokenToServer(newToken);
        if (success) {
          await LocalStorage.saveToken(newToken);
        }
      }
    });

    // ✅ Listen for messages
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Create Android notification channel
  static Future<void> _createNotificationChannel() async {
    final androidPlugin =
        _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_channel);
      print('✅ Notification channel created.');
    } else {
      print('⚠️ Android notification plugin not available.');
    }
  }

  /// Save token to API server
  static Future<bool> _saveTokenToServer(String fcmToken) async {
    final bearerToken = await AuthService.getBearerToken();
    final userId = await getLoginUser();
    final clientId = userId.id.toString();
    final deviceId = await AuthService.getDeviceId();

    print('Bearer Token: $bearerToken');
    print('Client ID: $clientId');
    print('Device ID: $deviceId');

    if (bearerToken == null || bearerToken.isEmpty) {
      print("❌ No bearer token available.");
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
        print("✅ Token synced with server.");
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

  /// Handle foreground notification
  static void _handleMessage(RemoteMessage message) async {
    print('📩 Foreground message: ${message.toMap()}');

    final data = message.data;
    if (data['type'] == 'video_call') {
      CallManager.showIncomingCall(data);
      await showNotification(
        "Incoming Call",
        "${data['admin_name']} is calling...",
      );
    }
  }

  /// Handle background/terminated notification
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    print('📩 Background message: ${message.toMap()}');

    final data = message.data;
    if (data['type'] == 'video_call') {
      await CallManager.showIncomingCall(data);
      await showNotification(
        "Incoming Call",
        "${data['admin_name']} is calling...",
      );
    }
  }

  /// Initialize local notifications
  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotificationsPlugin.initialize(settings);
  }

  /// Show a local notification
  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'video_call_channel', // Must match with _channel.id
          'Video Calls',
          channelDescription: 'Incoming video calls',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(0, title, body, platformDetails);
  }
}
