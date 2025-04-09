import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/custom_widget.dart';
import 'package:synpitarn/models/notification.dart' as model;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/repositories/notification_repository.dart';
import 'package:synpitarn/models/user.dart';

class CustomAppBar  extends StatefulWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class CustomAppBarState extends State<CustomAppBar> {

  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getNotification() async {
    bool isLoggedIn = await getLoginStatus();
    if (isLoggedIn) {
      User loginUser = await getLoginUser();

      model.Notification notificationResponse = await NotificationRepository()
          .getNotificationCount(loginUser);

      if (notificationResponse.response.code == 200) {
        _notificationCount = notificationResponse.data;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomStyle.primary_color,
      flexibleSpace: Center(
        child: Padding(
          padding: CustomStyle.pagePadding(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 60,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
              CustomWidget.horizontalSpacing(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Syn Pitarn', style: CustomStyle.appTitle()),
                  Text('Pico Finance', style: CustomStyle.appSubTitle()),
                ],
              ),
              Spacer(),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {

                    },
                  ),
                  if (_notificationCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
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
        ),
      ),
    );
  }
}
