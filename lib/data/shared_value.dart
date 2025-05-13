import 'package:shared_preferences/shared_preferences.dart';
import 'package:synpitarn/data/language.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/loan.dart';

import 'package:synpitarn/models/user.dart';

Future<void> setLoginStatus(bool isLoggedIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);
}

Future<void> removeLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn');
}

Future<bool> getLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<void> setLoginUser(User loginUser) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('loginUser', loginUser.userResponseToJson());
}

Future<void> removeLoginUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('loginUser');
}

Future<User> getLoginUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('loginUser');
  if (userJson != null) {
    return User.userResponseFromJson(userJson);
  } else {
    return User.defaultUser();
  }
}

Future<void> setLanguage(LanguageType languageType) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', languageType.name);
  Language.currentLanguage = languageType;
}

Future<LanguageType> getLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String langString = prefs.getString('language') ?? LanguageType.my.name;
  return LanguageType.values.firstWhere(
        (e) => e.name == langString,
    orElse: () => LanguageType.my,
  );
}


