import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_rsa_value.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/biometric.dart';
import 'package:synpitarn/models/biometric_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/biometric_repository.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/util/rsaUtil.dart';

Future<void> createBiometricDialog(BuildContext context) async {
  final LocalAuthentication auth = LocalAuthentication();

  bool isBiometricSupported = await auth.canCheckBiometrics;
  bool isDeviceSupported = await auth.isDeviceSupported();
  String uuid = await getBiometricUUID();

  bool need = await getNeedBiometricLogin();
  if (!need) {
    return;
  }

  if (!isBiometricSupported || !isDeviceSupported) {
    print("Biometric authentication not available");
    return;
  }

  if (uuid == "") {
    print("biometric_uuid is null");
    createRegisterDialog(context);
  } else {
    createLoginDialog(context);
  }
}

Future<void> createRegisterDialog(BuildContext context) async {
  final LocalAuthentication auth = LocalAuthentication();
  String authState = "initial";

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Future<void> biometricAuthenticate() async {
            try {
              bool didAuthenticate = await auth.authenticate(
                localizedReason:
                    'Please authenticate yourself with your fingerprint',
                options: const AuthenticationOptions(
                  biometricOnly: true,
                  stickyAuth: true,
                ),
              );

              if (didAuthenticate) {
                print("Biometric successfully added!");
                handleBiometricRegister(context);
                setState(() => authState = "success");
              } else {
                print("Authentication failed");
                setState(() => authState = "failed");
              }
            } catch (e) {
              print("Error during authentication: $e");
              setState(() => authState = "failed");
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Wrap(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Is this your personal device?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "We will remember you next time login",
                        style: const TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Builder(
                          builder: (_) {
                            if (authState == "success") {
                              final AnimationController controller =
                                  AnimationController(
                                    vsync: Navigator.of(context),
                                  );
                              return Lottie.asset(
                                'assets/lottie/success.json',
                                controller: controller,
                                onLoaded: (composition) {
                                  controller.duration = composition.duration;
                                  controller.forward();
                                  controller.addStatusListener((status) {
                                    if (status == AnimationStatus.completed) {
                                      Navigator.pop(context);
                                      showErrorDialog(
                                        context,
                                        "Biometric successfully added!",
                                      );
                                    }
                                  });
                                },
                              );
                            } else if (authState == "failed") {
                              return Lottie.asset(
                                'assets/lottie/fail.json',
                                repeat: false,
                              );
                            } else {
                              return Icon(
                                Icons.fingerprint,
                                size: 50,
                                color: CustomStyle.primary_color,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomWidget.elevatedButton(
                        context: context,
                        enabled: true,
                        isLoading: false,
                        text: "YES",
                        onPressed: biometricAuthenticate,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> createLoginDialog(BuildContext context) async {
  final LocalAuthentication auth = LocalAuthentication();
  bool didAuthenticate = await auth.authenticate(
    localizedReason: 'Please authenticate to continue',
    options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
  );

  if (didAuthenticate) {
    print("Authenticated successfully!");
    await handleBiometricLogin(context);
  } else {
    print("Authentication failed");
  }
}

Future<void> handleBiometricRegister(BuildContext context) async {
  Biometric biometric = Biometric.defaultBiometric();
  biometric.publicKey = await getPublicKey();

  User loginUser = User.defaultUser();
  loginUser = await getLoginUser();

  BiometricResponse biometricResponse = await BiometricRepository().register(
    biometric,
    loginUser,
  );

  if (biometricResponse.response.code != 200) {
    String msg = biometricResponse.response.message.toLowerCase();
    showErrorDialog(context, msg);
  } else {
    await setBiometricUserID(loginUser.id.toString());
    await setBiometricUUID(biometricResponse.data.biometricUuid);
    print("Successfully Biometric Login");
  }
}

Future<void> handleBiometricLogin(BuildContext context) async {
  Biometric biometric = Biometric.defaultBiometric();
  biometric.publicKey = await getPublicKey();
  biometric.biometricUuid = await getBiometricUUID();

  BiometricResponse biometricChallengeResponse = await BiometricRepository()
      .challenge(biometric);
  if (biometricChallengeResponse.response.code != 200) {
    String msg = biometricChallengeResponse.response.message.toLowerCase();
    CustomWidget.showDialogWithoutStyle(context: context, msg: msg);
    return;
  }

  await runRSASignatureGenerator(biometricChallengeResponse.data.challenge);
  biometric.signature = await getSignature();

  UserResponse biometricLoginResponse = await BiometricRepository().login(
    biometric,
  );
  if (biometricLoginResponse.response.code != 200) {
    String msg = biometricLoginResponse.response.message.toLowerCase();
    CustomWidget.showDialogWithoutStyle(context: context, msg: msg);
    return;
  }

  print("Successfully Biometric Login");
  RouteService.login(context, biometricLoginResponse.data);
}

Future<void> showErrorDialog(BuildContext context, String errorMessage) async {
  await CustomWidget.showDialogWithoutStyle(
    context: context,
    msg: errorMessage,
  );
}
