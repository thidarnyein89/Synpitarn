import 'dart:convert';

class NotificationModel {
  final int id;
  final String type;
  final String notifiable;
  final int notifyId;
  final NotificationData data;
  final String? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.notifiable,
    required this.notifyId,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      notifiable: json['notifiable'],
      notifyId: json['notify_id'],
      data: NotificationData.fromJson(jsonDecode(json['data'])),
      readAt: json['read_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class NotificationData {
  final String title;
  final String content;
  final String mmContent;
  final String thContent;
  final String enContent;
  final String mmTitle;
  final String thTitle;
  final String enTitle;

  NotificationData({
    required this.title,
    required this.content,
    required this.mmContent,
    required this.thContent,
    required this.enContent,
    required this.mmTitle,
    required this.thTitle,
    required this.enTitle,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'],
      content: json['content'],
      mmContent: json['mm_content'],
      thContent: json['th_content'],
      enContent: json['en_content'],
      mmTitle: json['mm_title'],
      thTitle: json['th_title'],
      enTitle: json['en_title'],
    );
  }
}
