import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'forget-password.dart';

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
      isPhoneValidate = phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  void _validatePinValue() {
    setState(() {
      pinError = null;
      isPinValidate = pinController.text.isNotEmpty && pinController.text.length == 6;
    });
  }

  void handleLogin() {
    setState(() {
      phoneError = phoneController.text.isEmpty ? "Phone number cannot be empty" : null;
      pinError = pinController.text.isEmpty ? "PIN cannot be empty" : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png', // Replace with your logo asset
                height: 100,
              ),
              SizedBox(height: 10),
              Text(
                'Welcome from Synpitarn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 100),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                ],
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  prefixText: '+66 ',
                  border: OutlineInputBorder(),
                  errorText: phoneError,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: pinController,
                obscureText: _isObscured,
                keyboardType: TextInputType.phone,inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  LengthLimitingTextInputFormatter(6), // Limit to 10 digits
                ],
                decoration: InputDecoration(
                  labelText: 'PIN',
                  border: OutlineInputBorder(),
                  errorText: pinError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
                  );
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      text: "Forgot PIN code",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isPhoneValidate && isPinValidate ? handleLogin : null, // Disable when fields are empty
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to signup or relevant page
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account, ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: "click here",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
