class CallModel {
  final String channelId;
  final String status;

  CallModel({required this.channelId, required this.status});

  factory CallModel.fromMap(Map<String, dynamic> data) {
    return CallModel(channelId: data['channelId'], status: data['status']);
  }
}
