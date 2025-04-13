import 'dart:ui';

import 'package:flutter/material.dart';

class CustomStyle {
  static const Color primary_color = const Color(0xFF2E3097);

  static const Color secondary_color = const Color(0xFFEAD86C);

  static const Color icon_color = Colors.black54;

  static TextStyle appTitle() {
    return TextStyle(
        fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
  }

  static TextStyle appSubTitle() {
    return TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);
  }

  static TextStyle title() {
    return TextStyle(
      fontSize: 18,
    );
  }

  static TextStyle titleBold() {
    return TextStyle(fontSize: title().fontSize, fontWeight: FontWeight.bold);
  }

  static TextStyle subTitle() {
    return TextStyle(
      fontSize: 16,
    );
  }

  static TextStyle subTitleBold() {
    return TextStyle(
        fontSize: subTitle().fontSize, fontWeight: FontWeight.bold);
  }

  static TextStyle body() {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
    );
  }

  static TextStyle bodyUnderline() {
    return TextStyle(
      fontSize: body().fontSize,
      color: Colors.black,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle bodyRedColor() {
    return TextStyle(
      fontSize: body().fontSize,
      color: Colors.red,
    );
  }

  static TextStyle bodyWhiteColor() {
    return TextStyle(
      fontSize: 16,
      color: Colors.white,
    );
  }

  static EdgeInsetsGeometry pagePadding() {
    return EdgeInsets.symmetric(horizontal: 20.0, vertical: 20);
  }

  static EdgeInsetsGeometry sliderPadding() {
    return EdgeInsets.symmetric(horizontal: 10.0, vertical: 10);
  }

  static EdgeInsetsGeometry topPadding() {
    return EdgeInsets.symmetric(vertical: 20);
  }

  static EdgeInsetsGeometry pageWithoutTopPadding() {
    final padding = pagePadding() as EdgeInsets;
    return EdgeInsets.only(
        top: 0,
        right: padding.right,
        bottom: padding.bottom,
        left: padding.left);
  }
}
