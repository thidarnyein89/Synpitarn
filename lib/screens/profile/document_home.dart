import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/register_step.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/language_service.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/l10n/app_localizations.dart';

class DocumentHomePage extends StatefulWidget {
  const DocumentHomePage({super.key});

  @override
  DocumentHomeState createState() => DocumentHomeState();
}

class DocumentHomeState extends State<DocumentHomePage> {
  final PageController _pageController = PageController();
  User loginUser = User.defaultUser();
  List<StepData> stepList = [];

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getInitData() async {
    loginUser = await getLoginUser();
    stepList = StepData.getDocumentSteps();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: AppLocalizations.of(context)!.documents),
      body: SingleChildScrollView(
        child: Column(children: [createProfileCard()]),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: ConstantData.HOME_INDEX,
        onItemTapped: (index) {
          setState(() {
            ConstantData.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }

  Widget createProfileCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: stepList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final item = stepList[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: InkWell(
              onTap: () {
                RouteService.goToNavigator(context, item.page);
              },
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 40,
                          color: CustomStyle.primary_color,
                        ),
                        CustomWidget.verticalSpacing(),
                        Text(
                          LanguageService.translateKey(context, item.text),
                          textAlign: TextAlign.center,
                          style: CustomStyle.body(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
