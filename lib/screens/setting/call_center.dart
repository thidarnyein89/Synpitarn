import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class CallCenter extends StatelessWidget {
  const CallCenter({super.key});

  final String phone = '09987654321';

  Future<void> _callNow() async {
    final Uri uri = Uri.parse('tel:$phone');

    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      debugPrint('Cannot launch phone dialer');
    }
  }

  Future<void> _openFacebookPage() async {
    final Uri fbAppUri = Uri.parse(
      'fb://facewebmodal/f?href=https://www.facebook.com/synpitarn/',
    ); // Change to your page

    try {
      final launched = await launchUrl(
        fbAppUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        debugPrint('Launch failed');
      }
    } catch (e) {
      debugPrint('Error launching: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Call Centre'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Call us on mobile',
                style: TextStyle(
                  color: Colors.black, // Normal text color
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              CustomWidget.elevatedButton(
                onPressed: _callNow,
                icon: CupertinoIcons.phone,
                text: 'Call Centre',
              ),
              Divider(thickness: 1, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Reach us online',
                style: TextStyle(
                  color: Colors.black, // Normal text color
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              CustomWidget.elevatedButtonOutline(
                onPressed: _openFacebookPage,
                icon: Iconsax.message_text,
                text: 'Messenger',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
