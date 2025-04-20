import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QrCode {
  String photo = "";
  String string = "";

  QrCode.defaultQrCode();

  QrCode({
    required this.photo,
    required this.string,
  });

  factory QrCode.fromJson(Map<String, dynamic> json) {
    return QrCode(
      photo: json['photo'],
      string: json['string'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'string': string,
    };
  }
}
