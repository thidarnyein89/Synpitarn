import 'package:flutter/material.dart';
import 'package:synpitarn/main.dart';
import 'package:synpitarn/screens/videocall/video_call_screen.dart';

class CallManager {
  static void showIncomingCall(Map<String, dynamic> data) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false, // prevent dismiss by tap outside
      builder:
          (_) => AlertDialog(
            title: Text("📞 Incoming Call"),
            content: Text("Call from ${data['caller_id']}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  // ❌ Decline call logic (optional: notify backend)
                },
                child: Text("Decline", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  startAgoraCall(data); // ✅ Accept call
                },
                child: Text("Accept"),
              ),
            ],
          ),
    );
  }

  static void startAgoraCall(Map<String, dynamic> data) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (_) => VideoCallScreen(
                channelId: data['channel'],
                token: data['token'],
                callerId: data['caller_id'],
              ),
        ),
      );
    }
  }
}
