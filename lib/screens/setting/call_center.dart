import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class CallCenterPage extends StatefulWidget {
  const CallCenterPage({super.key});

  @override
  CallCenterState createState() => CallCenterState();
}

class CallCenterState extends State<CallCenterPage> {
  final String phone = '+66818225285';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  Future<void> _openMessengerChat() async {
    try {
      final messengerUri =
          Uri.parse("fb-messenger://user-thread/${ConstantData.MESSENGER_ID}");

      await launchUrl(messengerUri, mode: LaunchMode.platformDefault);
    } catch (e) {
      await CustomWidget.showDialogWithoutStyle(
          context: context, msg: "Could not launch Messenger");
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
                context: context,
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
                context: context,
                onPressed: _openMessengerChat,
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
