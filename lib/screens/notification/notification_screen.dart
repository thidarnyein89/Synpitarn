import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/notification.dart';
import 'package:synpitarn/models/notification_response.dart' as model;
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/notification_repository.dart';
import 'package:synpitarn/screens/components/app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notificationLists = [];
  bool isLoading = false;

  @override
  void initState() {
    // isLoading = true;
    super.initState();
    getNotification();
  }

  Future<void> getNotification() async {
    bool isLoggedIn = await getLoginStatus();
    if (isLoggedIn) {
      User loginUser = await getLoginUser();

      model.NotificationResponse notificationResponse =
          await NotificationRepository().getNotificationLists(loginUser);

      if (notificationResponse.response.code == 200) {
        notificationLists = notificationResponse.data;
      }
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: notificationLists.isEmpty
          ? Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: notificationLists.length,
                itemBuilder: (context, index) {
                  final item = notificationLists[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.data.enTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'dd MMM yyyy',
                                ).format(item.createdAt.toLocal()),
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            item.data.enContent,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
