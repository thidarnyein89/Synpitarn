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

  static TextStyle bodyOpacity() {
    return TextStyle(
      fontSize: 14,
      color: Colors.black.withAlpha((0.3 * 255).toInt()),
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
    return TextStyle(fontSize: body().fontSize, color: Colors.red, height: 1.5);
  }

  static TextStyle bodyBold() {
    return TextStyle(fontSize: body().fontSize, fontWeight: FontWeight.bold);
  }

  static TextStyle bodyItalic() {
    return TextStyle(fontSize: body().fontSize, fontStyle: FontStyle.italic);
  }

  static TextStyle bodyLineThrough() {
    return TextStyle(
      fontSize: body().fontSize,
      decoration: TextDecoration.lineThrough,
    );
  }

  static TextStyle bodyWhiteColor() {
    return TextStyle(
      fontSize: 16,
      color: Colors.white,
    );
  }

  static TextStyle bodyGreenColor() {
    return TextStyle(
      fontSize: body().fontSize,
      color: Colors.green,
    );
  }

  static TextStyle bodyGreyColor() {
    return TextStyle(
      fontSize: body().fontSize,
      color: Colors.grey[600],
    );
  }

  static TextStyle linkStyle() {
    return TextStyle(
      fontSize: body().fontSize,
      color: Colors.blue,
      decoration: TextDecoration.none,
    );
  }

  static EdgeInsetsGeometry pagePadding() {
    return EdgeInsets.symmetric(horizontal: 20.0, vertical: 20);
  }

  static EdgeInsetsGeometry pagePaddingMedium() {
    return EdgeInsets.symmetric(horizontal: 15.0, vertical: 15);
  }

  static EdgeInsetsGeometry pagePaddingSmall() {
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
