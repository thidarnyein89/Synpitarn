import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/screens/auth/register.dart';
import 'package:synpitarn/screens/auth/forget_password.dart';
import 'package:synpitarn/l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool _isObscured = true;
  String? phoneError;
  String? pinError;
  bool isPhoneValidate = false;
  bool isPinValidate = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkBiometricAvailable();
    phoneController.addListener(_validatePhoneValue);
    pinController.addListener(_validatePinValue);
  }

  @override
  void dispose() {
    phoneController.dispose();
    pinController.dispose();
    super.dispose();
  }

  checkBiometricAvailable() async {
    bool biometricAvailable = await auth.canCheckBiometrics;
    if (biometricAvailable) {
      createBiometricDialog(context);
    }
  }

  Future<void> createBiometricDialog(BuildContext context) async {
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
            // State: "initial", "success", "failed"

            Future<void> biometricAuthenticate() async {
              try {
                bool isBiometricSupported = await auth.canCheckBiometrics;
                bool isDeviceSupported = await auth.isDeviceSupported();

                if (!isBiometricSupported || !isDeviceSupported) {
                  print("Biometric authentication not available");
                  setState(() => authState = "failed");
                  return;
                }

                bool didAuthenticate = await auth.authenticate(
                  localizedReason: 'Please authenticate to continue',
                  options: const AuthenticationOptions(
                    biometricOnly: true,
                    stickyAuth: true,
                  ),
                );

                if (didAuthenticate) {
                  print("Authenticated successfully!");
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
                          'Quick and Easier Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Place your finger on fingerprint button to log in",
                          style: const TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: biometricAuthenticate,
                          child: SizedBox(
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
                                      controller.duration =
                                          composition.duration;
                                      controller.forward();
                                      controller.addStatusListener((status) {
                                        if (status ==
                                            AnimationStatus.completed) {
                                          Navigator.pop(context);
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
                        ),
                        const SizedBox(height: 50),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
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

  void _validatePhoneValue() {
    setState(() {
      phoneError = null;
      isPhoneValidate =
          phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  void _validatePinValue() {
    setState(() {
      pinError = null;
      isPinValidate =
          pinController.text.isNotEmpty && pinController.text.length == 6;
    });
  }

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
    });

    User user = User.defaultUser();
    user.phoneNumber = phoneController.text;
    user.code = pinController.text;
    user.type = "pincode";

    UserResponse loginResponse = await AuthRepository().login(user);

    if (loginResponse.response.code != 200) {
      String msg = loginResponse.response.message.toLowerCase();

      if (msg.contains("phone")) {
        phoneError = loginResponse.response.message;
      } else if (msg.contains("pin")) {
        pinError = loginResponse.response.message;
      } else {
        showErrorDialog(msg);
      }
    } else {
      RouteService.login(context, loginResponse.data);
    }

    isLoading = false;
    setState(() {});
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: CustomStyle.pagePadding(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/synpitarn.jpg', height: 180),
                      Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.welcomeMessage,
                        style: CustomStyle.titleBold(),
                      ),
                      CustomWidget.verticalSpacing(),
                      CustomWidget.verticalSpacing(),
                      CustomWidget.phoneTextField(
                        controller: phoneController,
                        label: AppLocalizations.of(context)!.phoneNumber,
                        errorText: phoneError,
                      ),
                      CustomWidget.pinTextField(
                        controller: pinController,
                        label: AppLocalizations.of(context)!.pin,
                        isObscured: _isObscured,
                        errorText: pinError,
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage(),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context)!.forgotPinCode,
                            style: CustomStyle.body(),
                          ),
                        ),
                      ),
                      CustomWidget.verticalSpacing(),
                      CustomWidget.elevatedButton(
                        context: context,
                        enabled: isPhoneValidate && isPinValidate,
                        isLoading: isLoading,
                        text: AppLocalizations.of(context)!.continueText,
                        onPressed: handleLogin,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text:
                                AppLocalizations.of(
                                  context,
                                )!.doNotHaveAnAccount,
                            style: CustomStyle.body(),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.clickHere,
                                style: CustomStyle.bodyUnderline(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomWidget.verticalSpacing(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
