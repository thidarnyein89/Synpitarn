import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/custom_widget.dart';
import 'package:synpitarn/screens/auth/otp.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/otp.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';

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

    OTP otpResponse = await AuthRepository().getOTP(user);

    if (otpResponse.response.code != 200) {
      phoneError = otpResponse.response.message;
    } else {
      user.code = otpResponse.data;
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
      appBar: CustomAppBar(),
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
                      Text('Forgot PIN code', style: CustomStyle.titleBold()),
                      CustomWidget.verticalSpacing(),
                      CustomWidget.verticalSpacing(),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          prefixText: '+66 ',
                          border: OutlineInputBorder(),
                          errorText: phoneError,
                        ),
                      ),
                      CustomWidget.verticalSpacing(),
                      ElevatedButton(
                        onPressed:
                            isPhoneValidate && !isLoading
                                ? handleResetPin
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomStyle.primary_color,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            isLoading
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 16, // Match text height
                                      width: 16, // Keep it proportional
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2, // Adjust thickness
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Please Wait...',
                                      style: CustomStyle.bodyWhiteColor(),
                                    ),
                                  ],
                                )
                                : Text(
                                  'Reset PIN code',
                                  style: CustomStyle.bodyWhiteColor(),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: AppConfig.PROFILE_INDEX,
        onItemTapped: (index) {
          setState(() {
            AppConfig.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }
}
