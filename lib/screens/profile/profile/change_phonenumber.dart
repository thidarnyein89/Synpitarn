import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/repositories/data_repository.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/repositories/profile_repository.dart';
import 'package:synpitarn/screens/auth/otp.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/nrc.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/profile/profile/change_phone_otp.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/route_service.dart';

class ChangePhoneNumberPage extends StatefulWidget {
  const ChangePhoneNumberPage({super.key});

  @override
  ChangePhoneNumberState createState() => ChangePhoneNumberState();
}

class ChangePhoneNumberState extends State<ChangePhoneNumberPage> {
  User loginUser = User.defaultUser();

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
    await CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Change Phone Number'),
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
                              controller: phoneController,
                              label: 'Phone number',
                              errorText: phoneError),
                          CustomWidget.elevatedButton(
                              enabled: isPhoneValidate,
                              isLoading: isLoading,
                              text: 'Change Phone Number',
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
