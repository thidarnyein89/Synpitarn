import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class AboutUS {
  IconData icon = Icons.home;
  String titleMM = "";
  String titleEN = "";
  String titleTHAI = "";
  String descriptionMM = "";
  String descriptionEN = "";
  String descriptionTHAI = "";

  static const Map<String, IconData> iconMap = {
    "group": RemixIcons.group_line,
    "profile": RemixIcons.profile_line,
    "auction": RemixIcons.auction_line,
    "award": RemixIcons.award_line,
    "question": RemixIcons.question_line,
    "file": RemixIcons.file_paper_2_line,
  };

  AboutUS.defaultAboutUs();

  AboutUS({
    required this.icon,
    required this.titleMM,
    required this.titleEN,
    required this.titleTHAI,
    required this.descriptionMM,
    required this.descriptionEN,
    required this.descriptionTHAI,
  });

  factory AboutUS.fromJson(Map<String, dynamic> json) {
    return AboutUS(
      icon: getIconFromString(json['icon']),
      titleMM: json['title_mm'],
      titleEN: json['title_en'],
      titleTHAI: json['title_thai'],
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
      'descriptionMM': descriptionMM,
      'descriptionEN': descriptionEN,
      'descriptionTHAI': descriptionTHAI,
    };
  }

  static String getIconName(IconData icon) {
    return icon.toString();
  }

  static IconData getIconFromString(String iconName) {
    return iconMap[iconName] ?? RemixIcons.error_warning_line;
  }
}
