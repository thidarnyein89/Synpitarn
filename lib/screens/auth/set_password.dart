import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetPasswordPage extends StatefulWidget {
  User loginUser;

  SetPasswordPage({super.key, required this.loginUser});

  @override
  SetPasswordState createState() => SetPasswordState();
}

class SetPasswordState extends State<SetPasswordPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pin1Controller = TextEditingController();
  final TextEditingController pin2Controller = TextEditingController();

  bool _isObscured1 = true;
  bool _isObscured2 = true;
  String? pin1Error;
  String? pin2Error;
  bool isPin1Validate = false;
  bool isPin2Validate = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.loginUser.phoneNumber;
    pin1Controller.addListener(_validatePin1Value);
    pin2Controller.addListener(_validatePin2Value);
  }

  @override
  void dispose() {
    phoneController.dispose();
    pin1Controller.dispose();
    pin2Controller.dispose();
    super.dispose();
  }

  void _validatePin1Value() {
    setState(() {
      pin1Error = null;
      isPin1Validate =
          pin1Controller.text.isNotEmpty && pin1Controller.text.length == 6;
    });
  }

  void _validatePin2Value() {
    setState(() {
      pin2Error = null;
      isPin2Validate =
          pin2Controller.text.isNotEmpty && pin2Controller.text.length == 6;
    });
  }

  Future<void> handleSetPassowrd() async {
    if (pin1Controller.text != pin2Controller.text) {
      pin2Error = "PIN code must be identical";
      isPin2Validate = false;
      setState(() {});
    } else {
      setState(() {
        isLoading = true;
      });

      User user = User.defaultUser();
      user.token = widget.loginUser.token;
      user.forgetPassword = widget.loginUser.forgetPassword;
      user.phoneNumber = phoneController.text;
      user.code = pin1Controller.text;

      UserResponse loginResponse = await AuthRepository().setPassword(user);

      if (loginResponse.response.code != 200) {
        pin1Error = loginResponse.response.message;
      } else {
        List<Map<String, dynamic>> msg = [];

        msg.add({
          "text": AppLocalizations.of(context)!.rememberPhonePincode1,
          "style": TextStyle(color: Colors.black)
        });
        msg.add({
          "text": user.phoneNumber,
          "style": TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        });
        msg.add({
          "text": AppLocalizations.of(context)!.rememberPhonePincode2,
          "style": TextStyle(color: Colors.black)
        });
        msg.add({
          "text": user.code,
          "style": TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        });
        msg.add({
          "text": AppLocalizations.of(context)!.rememberPhonePincode3,
          "style": TextStyle(color: Colors.black)
        });

        CustomWidget.showDialogWithStyle(
          context: context,
          msg: msg,
        ).then((_) {
          RouteService.login(context, loginResponse.data);
        });
      }

      isLoading = false;
      setState(() {});
    }
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
                      Text(
                        AppLocalizations.of(context)!.setPincode,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      CustomWidget.verticalSpacing(),
                      CustomWidget.phoneTextField(
                          controller: phoneController,
                          label: AppLocalizations.of(context)!.phoneNumber,
                          readOnly: true),
                      CustomWidget.pinTextField(
                          controller: pin1Controller,
                          label: AppLocalizations.of(context)!.pin,
                          errorText: pin1Error,
                          isObscured: _isObscured1,
                          onPressed: () {
                            setState(() {
                              _isObscured1 = !_isObscured1;
                            });
                          }),
                      CustomWidget.pinTextField(
                          controller: pin2Controller,
                          label: AppLocalizations.of(context)!.confirmPin,
                          errorText: pin2Error,
                          isObscured: _isObscured2,
                          onPressed: () {
                            setState(() {
                              _isObscured2 = !_isObscured2;
                            });
                          }),
                      CustomWidget.elevatedButton(
                          context: context,
                          enabled: isPin1Validate && isPin2Validate,
                          isLoading: isLoading,
                          text: AppLocalizations.of(context)!.setNewPassword,
                          onPressed: handleSetPassowrd),
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
