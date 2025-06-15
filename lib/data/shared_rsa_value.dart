import 'package:shared_preferences/shared_preferences.dart';

Future<void> setPrivateKey(String privateKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('privateKey', privateKey);
}

Future<void> removePrivateKey() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('privateKey');
}

Future<String> getPrivateKey() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('privateKey') ?? "";
}

Future<void> setPublicKey(String publicKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('publicKey', publicKey);
}

Future<void> removePublicKey() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('publicKey');
}

Future<String> getPublicKey() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('publicKey') ?? "";
}

Future<void> setBiometricUserID(String userID) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('biometricUserID', userID);
}

Future<void> removeBiometricUserID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('biometricUserID');
}

Future<String> getBiometricUserID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('biometricUserID') ?? "";
}

Future<void> setBiometricUUID(String biometricUUID) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('biometricUUID', biometricUUID);
}

Future<void> removeBiometricUUID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('biometricUUID');
}

Future<String> getBiometricUUID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('biometricUUID') ?? "";
}

Future<void> setSignature(String signature) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('signature', signature);
}

Future<void> removeSignature() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('signature');
}

Future<String> getSignature() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('signature') ?? "";
}

Future<void> setNeedBiometricLogin(bool need) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('needBiometricLogin', need);
}

Future<void> removeBiometricLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('needBiometricLogin');
}

Future<bool> getNeedBiometricLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('needBiometricLogin') ?? false;
}
