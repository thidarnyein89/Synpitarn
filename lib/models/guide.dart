import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/language.dart';

class Guide {
  IconData icon = Icons.home;
  String titleMM = "";
  String titleEN = "";
  String titleTHAI = "";
  String stepMM = "";
  String stepEN = "";
  String stepTHAI = "";

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
    };
  }

  static String getIconName(IconData icon) {
    return icon.toString();
  }

  static IconData getIconFromString(String iconName) {
    return iconMap[iconName] ?? Icons.error;
  }

  String getTitle() {
    switch (Language.currentLanguage) {
      case LanguageType.my:
        return titleMM;
      case LanguageType.th:
        return titleTHAI;
      default:
        return titleEN;
    }
  }

  String getStep() {
    switch (Language.currentLanguage) {
      case LanguageType.my:
        return stepMM;
      case LanguageType.th:
        return stepTHAI;
      default:
        return stepEN;
    }
  }
}
