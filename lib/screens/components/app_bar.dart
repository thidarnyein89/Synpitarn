import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/models/notification_response.dart' as model;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/repositories/notification_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/notification/notification_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    // getNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getNotification() async {
    bool isLoggedIn = await getLoginStatus();
    if (isLoggedIn) {
      User loginUser = await getLoginUser();

      model.NotificationResponse notificationResponse =
          await NotificationRepository().getNotificationLists(loginUser);

      if (notificationResponse.response.code == 200) {
        _notificationCount = notificationResponse.data.length;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomStyle.primary_color,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          SizedBox(width: 16), // Padding on the left
          Image.asset(
            'assets/images/logo.png',
            height: 40, // Smaller so it fits well
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
          CustomWidget.horizontalSpacing(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Syn Pitarn', style: CustomStyle.appTitle())],
          ),
          Spacer(),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$_notificationCount',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
