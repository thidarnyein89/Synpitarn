// lib/screens/incoming_call_screen.dart

import 'package:flutter/material.dart';

class IncomingCallScreen extends StatelessWidget {
  final String callerName;
  final String callerNumber;

  const IncomingCallScreen({
    super.key,
    required this.callerName,
    required this.callerNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                'assets/avatar.png',
              ), // or use NetworkImage
            ),
            const SizedBox(height: 24),
            Text(
              callerName,
              style: const TextStyle(color: Colors.white, fontSize: 26),
            ),
            const SizedBox(height: 8),
            Text(
              callerNumber,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pop(); // Accept call
                    // Navigate to call screen or start call logic
                  },
                  child: const Icon(Icons.call),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop(); // Decline call
                  },
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
