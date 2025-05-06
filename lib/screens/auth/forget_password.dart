import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/auth/otp.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPasswordPage> {
  final TextEditingController phoneController = TextEditingController();

  String? phoneError;
  bool isPhoneValidate = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_validatePhoneValue);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _validatePhoneValue() {
    setState(() {
      phoneError = null;
      isPhoneValidate =
          phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  Future<void> handleResetPin() async {
    setState(() {
      isLoading = true;
    });

    User user = User.defaultUser();
    user.phoneNumber = phoneController.text;
    user.forgetPassword = true;

    UserResponse loginResponse = await AuthRepository().getOTP(user);

    if (loginResponse.response.code != 200) {
      phoneError = loginResponse.response.message;
    } else {
      user.code = loginResponse.data.code;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OTPPage(loginUser: user)),
      );
    }

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
                      Image.asset(
                        'assets/images/synpitarn.jpg',
                        height: 180,
                      ),
                      Text(AppLocalizations.of(context)!.forgotPinCode, style: CustomStyle.titleBold()),
                      CustomWidget.verticalSpacing(),
                      CustomWidget.verticalSpacing(),
                      CustomWidget.phoneTextField(
                          controller: phoneController,
                          label: AppLocalizations.of(context)!.phoneNumber,
                          errorText: phoneError),
                      CustomWidget.elevatedButton(
                          context: context,
                          enabled: isPhoneValidate,
                          isLoading: isLoading,
                          text: AppLocalizations.of(context)!.resetPinCode,
                          onPressed: handleResetPin),
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
