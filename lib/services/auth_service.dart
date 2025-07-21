import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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
    final url = Uri.parse('http://13.213.165.89/oauth/token');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': '1',
        'client_secret': 'hZRWtctTr9NwiipzBDZmHnZ8kuX3Crk6EuXPjD5c',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      return accessToken;
    } else {
      print('❌ Failed to get token: ${response.statusCode}');
      return null;
    }
  }

  static Future<String?> getDeviceId() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return null;
    }

    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        return androidInfo.id; // 👈 Return device ID
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor; // 👈 Return device ID
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
