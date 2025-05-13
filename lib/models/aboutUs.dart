import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:synpitarn/data/language.dart';

class AboutUS {
  IconData icon = Icons.home;
  String titleMM = "";
  String titleEN = "";
  String titleTHAI = "";
  bool isAboutUs = false;

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
    required this.isAboutUs,
  });

  factory AboutUS.fromJson(Map<String, dynamic> json) {
    return AboutUS(
      icon: getIconFromString(json['icon']),
      titleMM: json['title_mm'],
      titleEN: json['title_en'],
      titleTHAI: json['title_thai'],
      isAboutUs: json['is_about_us'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': getIconName(icon),
      'titleMM': titleMM,
      'titleEN': titleEN,
      'titleTHAI': titleTHAI,
      'isAboutUs': isAboutUs,
    };
  }

  static String getIconName(IconData icon) {
    return icon.toString();
  }

  static IconData getIconFromString(String iconName) {
    return iconMap[iconName] ?? RemixIcons.error_warning_line;
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
}
