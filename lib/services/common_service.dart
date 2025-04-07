import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:synpitarn/models/guide.dart';
import 'package:synpitarn/models/nrc.dart';
import 'package:synpitarn/models/aboutUs.dart';

class CommonService {

  Future<List<NRC>> readNRCData() async {
    final String response = await rootBundle.loadString('assets/json/nrcData.json');
    List<dynamic> jsonData = json.decode(response);
    List<NRC> nrcList = jsonData.map((data) => NRC.fromJson(data)).toList();
    return nrcList;
  }

  Future<List<Guide>> readGuideData() async {
    final String response = await rootBundle.loadString('assets/json/guide.json');
    List<dynamic> jsonData = json.decode(response);
    List<Guide> guideList = jsonData.map((data) => Guide.fromJson(data)).toList();
    return guideList;
  }

  Future<List<AboutUS>> readAboutUsData() async {
    final String response = await rootBundle.loadString('assets/json/aboutUs.json');
    List<dynamic> jsonData = json.decode(response);
    List<AboutUS> aboutList = jsonData.map((data) => AboutUS.fromJson(data)).toList();
    return aboutList;
  }

}