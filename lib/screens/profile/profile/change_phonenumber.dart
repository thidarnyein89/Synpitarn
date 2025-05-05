import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/repositories/profile_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/profile/profile/change_phone_otp.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePhoneNumberPage extends StatefulWidget {
  const ChangePhoneNumberPage({super.key});

  @override
  ChangePhoneNumberState createState() => ChangePhoneNumberState();
}

class ChangePhoneNumberState extends State<ChangePhoneNumberPage> {
  User loginUser = User.defaultUser();

  final TextEditingController currentPhoneController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? phoneError;
  bool isPhoneValidate = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_validatePhoneValue);
    getInitData();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> getInitData() async {
    loginUser = await getLoginUser();
    currentPhoneController.text = loginUser.phoneNumber;
    setState(() {});
  }

  void _validatePhoneValue() {
    setState(() {
      phoneError = null;
      isPhoneValidate =
          phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  Future<void> handleContinue() async {
    setState(() {
      isLoading = true;
    });

    var postBody = {
      "forget_password": false,
      "phone_number": phoneController.text
    };

    UserResponse userResponse =
        await ProfileRepository().getOTP(postBody, loginUser);

    if (userResponse.response.code == 200) {
      loginUser.code = userResponse.data.code;
      loginUser.phoneNumber = phoneController.text;
      loginUser.forgetPassword = false;

      RouteService.goToReplaceNavigator(
          context, ChangePhoneOTPPage(loginUser: loginUser));
    } else if (userResponse.response.code == 403) {
      await showErrorDialog(userResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(userResponse.response.message);
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(
        context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          PageAppBar(title: AppLocalizations.of(context)!.changePhoneNumber),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                    child: Column(
                  spacing: 0,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegisterTabBar(activeStep: 0),
                    Padding(
                      padding: CustomStyle.pageWithoutTopPadding(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget.phoneTextField(
                              controller: currentPhoneController,
                              label: AppLocalizations.of(context)!
                                  .currentPhoneNumber,
                              readOnly: true),
                          CustomWidget.phoneTextField(
                              controller: phoneController,
                              label: AppLocalizations.of(context)!.phoneNumber,
                              errorText: phoneError),
                          CustomWidget.elevatedButton(
                              context: context,
                              enabled: isPhoneValidate,
                              isLoading: isLoading,
                              text: AppLocalizations.of(context)!
                                  .changePhoneNumber,
                              onPressed: handleContinue),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            )
          ]);
        },
      ),
    );
  }
}
