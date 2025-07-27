import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synpitarn/util/constant.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    super.key,
    required this.channelId,
    required this.token,
    required this.callerId,
  });
  final String channelId;
  final String token;
  final String callerId;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final RtcEngine _engine;
  int? _remoteUid;
  bool _remoteUserJoined = false;
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isCameraOff = false;
  bool _isReady = false;

  // ✅ Track available audio devices (for debug)
  List<AudioDeviceInfo> _playbackDevices = [];
  List<AudioDeviceInfo> _recordingDevices = [];

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    _endVideoCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      body: Stack(
        children: [
          _remoteUserJoined ? _remoteVideo() : _renderLocalPreview(),
          if (_remoteUserJoined)
            Positioned(
              top: 16,
              left: 16,
              width: 120,
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: _renderLocalPreview(),
                ),
              ),
            ),
          Positioned(
            top: 30,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              child: IconButton(
                icon: const Icon(Icons.cameraswitch, color: Colors.white),
                onPressed: () {
                  _engine.switchCamera();
                },
              ),
            ),
          ),
          _toolbar(),
        ],
      ),
    );
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    // ✅ Enable audio/video
    await _engine.enableVideo();
    await _engine.enableAudio();

    // ✅ Listen for user join/leave events
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("✅ Local user joined: ${connection.localUid}");
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("✅ Remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
            _remoteUserJoined = true;
          });
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          debugPrint("❌ Remote user $remoteUid left");
          setState(() {
            _remoteUid = null;
            _remoteUserJoined = false;
          });
          _endVideoCall();
        },
        onAudioDeviceStateChanged: (deviceId, deviceType, deviceState) {
          debugPrint("🎧 Audio device changed: $deviceType → $deviceState");
        },
      ),
    );

    await _engine.startPreview();

    // ✅ Join channel
    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelId,
      uid: 0,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    // ✅ Detect audio devices (desktop only, mobile auto-manages)
    _loadAudioDevices();

    setState(() {
      _isReady = true;
    });
  }

  Future<void> _loadAudioDevices() async {
    try {
      final audioDeviceManager = await _engine.getAudioDeviceManager();

      // ✅ Playback devices (speakers/headphones)
      final playback = await audioDeviceManager.enumeratePlaybackDevices();
      debugPrint("🔊 Playback devices: $playback");

      // ✅ Recording devices (microphones)
      final recording = await audioDeviceManager.enumerateRecordingDevices();
      debugPrint("🎙️ Recording devices: $recording");

      setState(() {
        _playbackDevices = playback;
        _recordingDevices = recording;
      });
    } catch (e) {
      debugPrint("⚠️ Audio device enumeration not supported on mobile: $e");
    }
  }

  Widget _renderLocalPreview() {
    if (_isCameraOff) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.videocam_off, color: Colors.white, size: 48),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelId),
        ),
      );
    } else {
      return const Center(child: Text('Waiting for remote user to join...'));
    }
  }

  Widget _toolbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // ✅ Mute mic
            CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              radius: 24,
              child: IconButton(
                icon: Icon(
                  _isMuted ? Icons.mic_off : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() => _isMuted = !_isMuted);
                  _engine.muteLocalAudioStream(_isMuted);
                },
              ),
            ),

            // ✅ Speaker toggle (earpiece ↔ loudspeaker)
            CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              radius: 24,
              child: IconButton(
                icon: Icon(
                  _isSpeakerOn ? Icons.volume_up : Icons.hearing,
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() => _isSpeakerOn = !_isSpeakerOn);
                  await _engine.setEnableSpeakerphone(_isSpeakerOn);
                  debugPrint("🔊 Speakerphone: $_isSpeakerOn");
                },
              ),
            ),

            // ✅ Camera toggle
            CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              radius: 24,
              child: IconButton(
                icon: Icon(
                  _isCameraOff ? Icons.videocam_off : Icons.videocam,
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() => _isCameraOff = !_isCameraOff);
                  if (_isCameraOff) {
                    await _engine.muteLocalVideoStream(true);
                    await _engine.stopPreview();
                  } else {
                    await _engine.muteLocalVideoStream(false);
                    await _engine.startPreview();
                  }
                },
              ),
            ),

            // ✅ End Call
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.red,
              child: IconButton(
                icon: const Icon(Icons.call_end, color: Colors.white),
                onPressed: () async {
                  await _endVideoCall();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _endVideoCall() async {
    try {
      _engine.leaveChannel();
      _engine.release();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("❌ Agora dispose error: $e");
    }
  }
}
