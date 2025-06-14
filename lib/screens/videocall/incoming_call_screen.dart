import 'package:flutter/material.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({
    super.key,
    required this.callerName,
    required this.channelName,
    required this.onAccept,
  });
  final String callerName;
  final String channelName;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$callerName is calling'),
      content: Text('Incoming call on channel: $channelName'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Decline'),
        ),
        TextButton(onPressed: onAccept, child: const Text('Accept')),
      ],
    );
  }
}
