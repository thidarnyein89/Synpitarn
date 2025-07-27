import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:synpitarn/main.dart';
import 'package:synpitarn/screens/videocall/video_call_screen.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
class CallManager {
  static final Set<String> _processedCallIds = {};
  static bool _initialized = false;

  // ✅ NEW: Track if we already have an active call screen
  static bool _isInCallScreen = false;
  static void resetCallScreenState() {
    print("✅ CallManager reset → ready for next call");
    _isInCallScreen = false;
  }

  /// ✅ Show incoming call UI
  @pragma('vm:entry-point')
  static Future<void> showIncomingCall(Map<String, dynamic> data) async {
    final uuid = const Uuid().v4();
    print("📞 Incoming call payload: $data");

    final params = CallKitParams(
      id: uuid,
      nameCaller: data['admin_name'] ?? 'Unknown Caller',
      appName: 'Synpitarn',
      avatar: '',
      handle: data['caller_number'] ?? '1234567890',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      extra: {...data, "call_uuid": uuid},
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

  /// ✅ Initialize CallKit listener (and check cold start)
  static void initializeCallkitEventHandler() {
    if (_initialized) return;
    _initialized = true;

    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
      if (event == null) return;

      print("📞 Raw CallKitEvent: ${event.toString()}");

      final name = event.event; // ✅ event.event is String
      final body = event.body; // ✅ event.body is Map<String, dynamic>

      _handleCallKitEvent("$name", body);
    });

    _checkActiveCallOnColdStart();
  }

  /// ✅ Cold start pending active call
  static Future<void> _checkActiveCallOnColdStart() async {
    try {
      final activeCalls = await FlutterCallkitIncoming.activeCalls();
      if (activeCalls.isNotEmpty) {
        print("📲 Found active call on cold start: $activeCalls");

        final firstCall = activeCalls.first;
        final extra = firstCall['extra'] ?? {};
        final callUuid = extra['call_uuid'] ?? firstCall['id'];
        final channelId = extra['channel_name'];
        final token = extra['shared_token'];
        final callerId = extra['call_id'];

        if (callUuid != null && !_processedCallIds.contains(callUuid)) {
          _processedCallIds.add(callUuid);

          // ✅ Navigate automatically (since user likely already accepted)
          if (channelId != null && token != null && callerId != null) {
            print("✅ Navigating to VideoCallScreen after cold start...");
            _navigateToVideoCallScreen(channelId, token, callerId);
          } else {
            print("⚠️ Active call missing required data");
          }
        }
      } else {
        print("✅ No active calls found on cold start");
      }
    } catch (e) {
      print("❌ Error checking active call on cold start: $e");
    }
  }

  /// ✅ Handle live events
  static void _handleCallKitEvent(
    String? eventNameRaw,
    Map<String, dynamic>? body,
  ) {
    if (eventNameRaw == null) return;
    final eventName = eventNameRaw.toLowerCase();
    final extra = body?['extra'] ?? {};
    final callUuid = extra['call_uuid'] ?? body?['id'];

    // ✅ Prevent duplicates
    if (callUuid != null && _processedCallIds.contains(callUuid)) {
      print("⏩ Duplicate event for $callUuid ignored");
      return;
    }

    print('📞 CallKit Event: $eventName | Body: $body');

    if (eventName == 'event.actioncallaccept') {
      if (callUuid != null) _processedCallIds.add(callUuid);

      final channelId = extra['channel_name'];
      final token = extra['shared_token'];
      final callerId = extra['call_id'];

      if (channelId != null && token != null && callerId != null) {
        _navigateToVideoCallScreen(channelId, token, callerId);
      } else {
        print("❌ Missing call data for accept event");
      }
    }

    if (eventName == 'event.actioncalldecline') {
      if (callUuid != null) _processedCallIds.add(callUuid);
      print('📴 Call declined');
    }

    if (eventName == 'event.timeout') {
      if (callUuid != null) _processedCallIds.add(callUuid);
      print('⌛ Call timeout auto-decline');
    }
  }

  /// ✅ Safe navigation helper with duplicate prevention
  static void _navigateToVideoCallScreen(
    String channelId,
    String token,
    String callerId,
  ) {
    // ✅ Prevent duplicate navigation
    if (_isInCallScreen) {
      print("⏩ Already in VideoCallScreen, skipping navigation");
      return;
    }
    _isInCallScreen = true; // Mark as in call screen

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context == null) {
        print("⚠️ Navigator context null, retrying...");
        Future.delayed(const Duration(milliseconds: 500), () {
          final ctx = navigatorKey.currentContext;
          if (ctx != null) {
            _pushVideoCall(ctx, channelId, token, callerId);
          } else {
            print('❌ Still no context for navigation');
          }
        });
      } else {
        print('✅ Navigating to VideoCallScreen...');
        _pushVideoCall(context, channelId, token, callerId);
      }
    });
  }

  static void _pushVideoCall(
    BuildContext context,
    String channelId,
    String token,
    String callerId,
  ) async {
    // ✅ Remove callkit UI after accepting
    await FlutterCallkitIncoming.endAllCalls();

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder:
                (_) => VideoCallScreen(
                  channelId: channelId,
                  token: token,
                  callerId: callerId,
                ),
          ),
        )
        .then((_) {
          resetCallScreenState(); // ✅ Reset when user leaves call
        });
  }
}
