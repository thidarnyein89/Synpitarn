import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:synpitarn/main.dart';
import 'package:synpitarn/screens/videocall/video_call_screen.dart';
import 'package:uuid/uuid.dart';

class CallManager {
  static void showIncomingCall(Map<String, dynamic> data) async {
    final uuid = const Uuid().v4();

    final params = CallKitParams(
      id: uuid,
      nameCaller: data['caller_name'] ?? 'Unknown Caller',
      appName: 'My App',
      avatar: '',
      handle: data['caller_number'] ?? '1234567890',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      extra: {
        'userId': data['caller_id'],
        'channelId': data['channel_id'],
        'token': data['token'],
      },
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        actionColor: '#4CAF50',
      ),
      ios: IOSParams(iconName: 'CallKitIcon', handleType: 'generic'),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  /// Listen for CallKit events
  static void initializeCallkitEventHandler() {
    FlutterCallkitIncoming.onEvent.listen((event) {
      final eventNameRaw = event?.event; // This is the string
      final eventName =
          eventNameRaw?.toString().toLowerCase(); // Safe conversion
      final body = event?.body;

      print('📞 CallKit Event: $eventName');

      if (eventName == 'event.actioncallaccept' && body != null) {
        final extra = body['extra'] ?? {};
        final channelId = extra['channelId'];
        final token = extra['token'];
        final callerId = extra['userId'];

        print('👉 Call accepted with extra: $extra');

        if (channelId == null && token == null && callerId == null) {
          final context = navigatorKey.currentContext;
          if (context == null) return;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => VideoCallScreen(
                    channelId: 'gfdsgfsd',
                    token: 'gfdsgfds',
                    callerId: '123',
                  ),
            ),
          );
        } else {
          print('❌ Missing call data');
        }
      }

      if (eventName == 'event.actioncalldecline') {
        print('📴 Call declined');
      }
    });
  }
}
