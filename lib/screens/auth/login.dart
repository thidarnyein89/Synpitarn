import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/custom_widget.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/login.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/auth/register.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/screens/auth/forget_password.dart';
import 'package:synpitarn/data/app_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
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

    Login loginResponse = await AuthRepository().login(user);

    if (loginResponse.response.code != 200) {
      String msg = loginResponse.response.message.toLowerCase();

      if (msg.contains("phone")) {
        phoneError = loginResponse.response.message;
      } else {
        pinError = loginResponse.response.message;
      }
    } else {
      await setLoginUser(loginResponse.data);
      await setLoginStatus(true);

      setState(() {});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
                      Image.asset('assets/images/synpitarn.jpg', height: 180),
                      CustomWidget.verticalSpacing(),
                      Text(
                        'Welcome from Synpitarn',
                        style: CustomStyle.titleBold(),
                      ),
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
                      TextField(
                        controller: pinController,
                        obscureText: _isObscured,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          labelText: 'PIN',
                          border: OutlineInputBorder(),
                          errorText: pinError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                        ),
                      ),
                      CustomWidget.verticalSpacing(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage(),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot PIN code",
                            style: CustomStyle.body(),
                          ),
                        ),
                      ),
                      CustomWidget.verticalSpacing(),
                      ElevatedButton(
                        onPressed:
                            isPhoneValidate && isPinValidate && !isLoading
                                ? handleLogin
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
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Please Wait...',
                                      style: CustomStyle.bodyWhiteColor(),
                                    ),
                                  ],
                                )
                                : Text('Login', style: CustomStyle.bodyWhiteColor()),
                      ),
                      CustomWidget.verticalSpacing(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account, ",
                            style: CustomStyle.body(),
                            children: [
                              TextSpan(
                                text: "click here",
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
