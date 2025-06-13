// ignore_for_file: file_names

import 'dart:convert';

import 'package:convert/convert.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:synpitarn/data/shared_rsa_value.dart';

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair({
  int bitLength = 2048,
}) {
  final keyGen =
      RSAKeyGenerator()..init(
        ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          SecureRandom("Fortuna")..seed(
            KeyParameter(
              Uint8List.fromList(
                List.generate(32, (_) => DateTime.now().millisecond % 256),
              ),
            ),
          ),
        ),
      );

  return keyGen.generateKeyPair();
}

Uint8List rsaSign(Uint8List data, RSAPrivateKey privateKey) {
  final signer = Signer("SHA-256/RSA")
    ..init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

  final sig = signer.generateSignature(data) as RSASignature;
  return sig.bytes;
}

bool rsaVerify(Uint8List data, Uint8List signature, RSAPublicKey publicKey) {
  final signer = Signer("SHA-256/RSA")
    ..init(false, PublicKeyParameter<RSAPublicKey>(publicKey));

  return signer.verifySignature(data, RSASignature(signature));
}

Future<void> runRSAKeyGenerator() async {
  if (await getPrivateKey() != "") {
    return;
  }

  final pair = generateRSAKeyPair();
  final privateKey = pair.privateKey;
  final publicKey = pair.publicKey;

  final privatePEM = CryptoUtils.encodeRSAPrivateKeyToPem(privateKey);
  await setPrivateKey(privatePEM);

  final publicPEM = CryptoUtils.encodeRSAPublicKeyToPem(publicKey);
  await setPublicKey(publicPEM);
}

Future<void> runRSASignatureGenerator(String challenge) async {
  final privatePem = await getPrivateKey();
  final publicPem = await getPublicKey();

  final privateKey = CryptoUtils.rsaPrivateKeyFromPem(privatePem);
  final publicKey = CryptoUtils.rsaPublicKeyFromPem(publicPem);

  final messageBytes = Uint8List.fromList(utf8.encode(challenge));

  final signature = rsaSign(messageBytes, privateKey);
  final isValid = rsaVerify(messageBytes, signature, publicKey);

  if (isValid) {
    await setSignature(base64Encode(signature));
  } else {
    throw Exception("RSA Signature verification failed");
  }
}
