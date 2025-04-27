import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/screens/components/main_app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/route_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<SettingPage> {
  User loginUser = User.defaultUser();

  bool isPageLoading = true;

  @override
  void initState() {
    super.initState();
    getDefaultData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getDefaultData() async {
    isPageLoading = true;
    setState(() {});

    loginUser = await getLoginUser();

    isPageLoading = false;
    setState(() {});
  }

  Future<void> handleLogout() async {
    setLoginUser(User.defaultUser());
    setLoginStatus(false);
    setState(() {});

    RouteService.goToMain(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Setting'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(children: [
            if (isPageLoading)
              CustomWidget.loading()
            else
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                      child: Column(
                    spacing: 0,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: CustomStyle.pagePadding(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.elevatedButton(
                                text: 'Logout', onPressed: handleLogout)
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              )
          ]);
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: ConstantData.SETTING_INDEX,
        onItemTapped: (index) {
          setState(() {
            ConstantData.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }
}
