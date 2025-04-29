import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/meta.dart';
import 'package:synpitarn/models/notification.dart';
import 'package:synpitarn/models/notification_response.dart' as model;
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/notification_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/main_app_bar.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/auth_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  List<NotificationModel> notificationList = [];
  final NotificationRepository _repository = NotificationRepository();
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    readNotification();
    getNotification();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading &&
          _hasNextPage) {
        readNotification();

        getNotification();
      }
    });
  }

  Future<void> getNotification() async {
    setState(() => _isLoading = true);
    bool isLoggedIn = await getLoginStatus();
    if (isLoggedIn) {
      User loginUser = await getLoginUser();

      try {
        final result = await _repository.getNotificationList(
          loginRequest: loginUser,
          page: _currentPage,
        );
        setState(() {
          notificationList.addAll(result.data);
          _hasNextPage = result.meta.hasNextPage;
          _currentPage++;
        });
      } catch (e) {
        debugPrint('Error fetching notifications: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> readNotification() async {
    bool isLoggedIn = await getLoginStatus();
    if (isLoggedIn) {
      User loginUser = await getLoginUser();
      final notifyIds = notificationList.map((item) => item.id).toList();
      var postBody = {"ids": notifyIds};
      model.NotificationResponse notificationResponse =
          await NotificationRepository().readNotification(postBody, loginUser);

      if (notificationResponse.response.code == 200) {
        print(notificationResponse.response.message);
      } else if (notificationResponse.response.code == 403) {
        await showErrorDialog(notificationResponse.response.message);
        AuthService().logout(context);
      } else {
        showErrorDialog(notificationResponse.response.message);
      }
      setState(() {});
    }
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: "Notification"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: notificationList.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < notificationList.length) {
              return _buildNotificationTile(notificationList[index]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationModel item) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(item.createdAt.toLocal()),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(item.data.enContent, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
