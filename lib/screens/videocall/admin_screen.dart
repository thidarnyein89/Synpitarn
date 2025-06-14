import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/screens/videocall/incoming_call_screen.dart';
import 'package:synpitarn/screens/videocall/video_call_screen.dart';
import 'package:synpitarn/services/notification_service.dart';
import 'package:uuid/uuid.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // final TextEditingController _calleeController = TextEditingController();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // bool _isLoading = false;

  // void _startCall() async {
  //   final calleeId = _calleeController.text.trim();
  //   if (calleeId.isEmpty) return;

  //   setState(() => _isLoading = true);

  //   try {
  //     // Step 1: Generate channelId
  //     final String channelId = const Uuid().v4();
  //     final String callerId = 'admin'; // or actual logged-in UID

  //     // Step 2: Save call record in Firestore
  //     await _firestore.collection('calls').doc(calleeId).set({
  //       'channelId': channelId,
  //       'callerId': callerId,
  //       'status': 'incoming',
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });

  //     // Step 3: Send push notification
  //     await NotificationService.sendIncomingCallNotification(
  //       calleeId: calleeId,
  //       channelId: channelId,
  //       callerId: callerId,
  //     );

  //     // Step 4: Navigate to VideoCallScreen
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => VideoCallScreen(channelId: channelId),
  //       ),
  //     );
  //   } catch (e) {
  //     print('❌ Error: $e');
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Failed to start call: $e')));
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel - Start Call')),
    );
  }
}
