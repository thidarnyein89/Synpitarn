import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Guide {
  IconData icon = Icons.home;
  String titleMM = "";
  String titleEN = "";
  String titleTHAI = "";
  String stepMM = "";
  String stepEN = "";
  String stepTHAI = "";
  String descriptionMM = "";
  String descriptionEN = "";
  String descriptionTHAI = "";

  static const Map<String, IconData> iconMap = {
    "feed": Icons.feed_outlined,
    "calendar": Icons.calendar_month_outlined,
    "business": Icons.business_outlined,
  };

  Guide.defaultGuide();

  Guide({
    required this.icon,
    required this.titleMM,
    required this.titleEN,
    required this.titleTHAI,
    required this.stepMM,
    required this.stepEN,
    required this.stepTHAI,
    required this.descriptionMM,
    required this.descriptionEN,
    required this.descriptionTHAI,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      icon: getIconFromString(json['icon']),
      titleMM: json['title_mm'],
      titleEN: json['title_en'],
      titleTHAI: json['title_thai'],
      stepMM: json['step_mm'],
      stepEN: json['step_en'],
      stepTHAI: json['step_thai'],
      descriptionMM: json['description_mm'],
      descriptionEN: json['description_en'],
      descriptionTHAI: json['description_thai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': getIconName(icon),
      'titleMM': titleMM,
      'titleEN': titleEN,
      'titleTHAI': titleTHAI,
      'stepMM': stepMM,
      'stepEN': stepEN,
      'stepTHAI': stepTHAI,
      'descriptionMM': descriptionMM,
      'descriptionEN': descriptionEN,
      'descriptionTHAI': descriptionTHAI,
    };
  }

  static String getIconName(IconData icon) {
    return icon.toString();
  }

  static IconData getIconFromString(String iconName) {
    return iconMap[iconName] ?? Icons.error;
  }
}
