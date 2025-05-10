import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum ContentType { text, table }

class Data {
  String text = "";
  TextStyle? style;
  final String? url;
  String? phoneNumber = "";

  Data({required this.text, this.style, this.url, this.phoneNumber});
}

class ContentBlock {
  int? paddingLeft = 0;
  final ContentType type;
  final List<Data>? textData;
  final List<Map<String, List<Data>>>? tableData;

  ContentBlock.text(this.textData, {this.paddingLeft = 0})
      : type = ContentType.text,
        tableData = null;

  ContentBlock.table(this.tableData)
      : type = ContentType.table,
        textData = null;

  Future<void> _callNow(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');

    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      debugPrint('Cannot launch phone dialer');
    }
  }
}