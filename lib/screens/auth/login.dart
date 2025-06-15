import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/screens/auth/register.dart';
import 'package:synpitarn/screens/auth/forget_password.dart';
import 'package:synpitarn/screens/auth/biometric_helper.dart';
import 'package:synpitarn/l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';

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
    createBiometricDialog(context);
    phoneController.addListener(_validatePhoneValue);
    pinController.addListener(_validatePinValue);
  }

  @override
  void dispose() {
    phoneController.dispose();
    pinController.dispose();
    super.dispose();
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
