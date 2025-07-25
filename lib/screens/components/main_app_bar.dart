import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/models/notification_response.dart' as model;
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/repositories/notification_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/notification/notification_screen.dart';
import 'package:synpitarn/services/auth_service.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  MainAppBar({super.key});

  @override
  MainAppBarState createState() => MainAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class MainAppBarState extends State<MainAppBar> {
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

      model.NotificationResponse notificationResponse =
          await NotificationRepository().getNotificationCount(loginUser);

      if (notificationResponse.response.code == 200) {
        _notificationCount = notificationResponse.data;
      } else if (notificationResponse.response.code == 403) {
        await showErrorDialog(notificationResponse.response.message);
        AuthService().logout(context);
      } else {
        showErrorDialog(notificationResponse.response.message);
      }
      // setState(() {});
    }
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(
      context: context,
      msg: errorMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayCount =
        _notificationCount > 99 ? '99+' : _notificationCount.toString();
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
                  setState(() {
                    _notificationCount = 0;
                  });
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
                    child: Center(
                      child: Text(
                        '$displayCount',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
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
