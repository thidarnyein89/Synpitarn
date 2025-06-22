import 'package:flutter/material.dart';
import 'package:synpitarn/screens/videocall/incoming_call_screen.dart';
import 'package:synpitarn/screens/videocall/video_call_screen.dart';

class NotificationService {
  // static final _firebaseMessaging = FirebaseMessaging.instance;
  // static final _localNotifications = FlutterLocalNotificationsPlugin();

  // static Future<void> initialize() async {
  //   await _firebaseMessaging.requestPermission();

  //   const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const initSettings = InitializationSettings(android: androidInit);
  //   await _localNotifications.initialize(initSettings);

  //   final token = await _firebaseMessaging.getToken();
  //   print("🔔 FCM Token: $token");

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       print(message.notification!);
  //     }
  //   });
  // }

  void showIncomingCall(Map<String, dynamic> data) {
    final navigatorKey = GlobalKey<NavigatorState>();
    runApp(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: IncomingCallScreen(
          callerName: data['callerName'],
          channelName: data['channel'],
          onAccept: () {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder:
                    (_) =>
                        VideoCallScreen(channelId: data['channel'], token: ''),
              ),
            );
          },
        ),
      ),
    );
  }
}
