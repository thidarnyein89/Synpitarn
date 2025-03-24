import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/screens/auth/otp.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPasswordPage> {

  final TextEditingController phoneController = TextEditingController();
  String? phoneError;
  bool isPhoneValidate = false;

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
      isPhoneValidate = phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  void handleResetPin() {
    String phone = phoneController.text;

    phoneError = phone.isEmpty ? "Phone number cannot be empty" : null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OTPPage()),
    );
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
              Text(
                'Forgot PIN code',
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isPhoneValidate && isPhoneValidate ? handleResetPin : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Reset PIN code',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
