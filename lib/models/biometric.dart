import 'dart:convert';

class Biometric {
  String biometricUuid = "";
  String challenge = "";
  String publicKey = "";
  String signature = "";

  Biometric.defaultBiometric();

  Biometric({
    required this.biometricUuid,
    required this.challenge,
    required this.publicKey,
    required this.signature,
  });

  factory Biometric.biometricResponseFromJson(String str) =>
      Biometric.fromJson(json.decode(str));

  factory Biometric.fromJson(Map<String, dynamic> json) {
    return Biometric(
      biometricUuid: json['biometric_uuid'] ?? "",
      challenge: json['challenge'] ?? "",
      publicKey: json['public_key'] ?? "",
      signature: json['signature'] ?? "",
    );
  }
}
