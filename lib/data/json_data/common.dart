import 'package:flutter/material.dart';

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
}