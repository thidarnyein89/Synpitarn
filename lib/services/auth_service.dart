import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/route_service.dart';

class AuthService {
  Future<void> logout(BuildContext context) async {
    User loginUser = await getLoginUser();
    User user = User.defaultUser();
    user.phoneNumber = loginUser.phoneNumber;

    setLoginUser(user);
    setLoginStatus(false);

    RouteService.goToMain(context);
  }

  static Future<String?> getBearerToken() async {
    final url = Uri.parse('https://report.synpitarn.com/oauth/token');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': '3',
        'client_secret': 'plQw9nBbtTuPbBtp0T0iLwyHXgmy09IowlCNloCf',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      print('🔐 Got token: $accessToken');
      return accessToken;
    } else {
      print('❌ Failed to get token: ${response.statusCode}');
      return null;
    }
  }
}
