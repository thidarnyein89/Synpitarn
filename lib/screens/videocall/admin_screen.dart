import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/screens/videocall/video_call_screen.dart';
import 'package:synpitarn/services/notification_service.dart';
import 'package:uuid/uuid.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _channelController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  Future<void> _startCall() async {
    if (_formKey.currentState!.validate()) {
      final channelName = _channelController.text.trim();
      final token = _tokenController.text.trim();

      // ✅ Go to video call page
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => VideoCallScreen(
                channelId: channelName,
                token: token,
                callerId: 'Alic',
              ),
        ),
      );

      // ✅ After coming back from VideoCallScreen
      _channelController.clear(); // Clear the input field
    }
  }

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Channel Name")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _channelController,
                decoration: const InputDecoration(
                  labelText: 'Channel Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a channel name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  labelText: 'Token',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter token';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startCall,
                child: const Text("Start Call"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
