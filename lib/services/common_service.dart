import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:synpitarn/models/nrc.dart';

class CommonService {

  Future<List<NRC>> readNRCData() async {
    final String response = await rootBundle.loadString('assets/json/nrcData.json');
    List<dynamic> jsonData = json.decode(response);
    List<NRC> nrcList = jsonData.map((data) => NRC.fromJson(data)).toList();
    return nrcList;
  }

}