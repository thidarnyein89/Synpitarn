import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/services/route_service.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  SuccessState createState() => SuccessState();
}

class SuccessState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Appointment Success', isMainPage: true),
        body: Scaffold(
          backgroundColor: Colors.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: CustomStyle.pagePadding(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/synpitarn.jpg',
                            height: 180,
                          ),
                          Text(
                            'Thank you for submitting your loan application form.',
                            style: CustomStyle.subTitleBold(),
                          ),
                          CustomWidget.verticalSpacing(),
                          CustomWidget.verticalSpacing(),
                          Text(
                            'Syn Pitarn staff are reviewing your loan application. We may have to contact you to re-upload any document that is not clear. The next step is for you to have a quick video call with our staff at the time and date you previously selected.',
                            style: CustomStyle.body(),
                          ),
                          CustomWidget.verticalSpacing(),
                          CustomWidget.elevatedButton(
                              enabled: true,
                              isLoading: false,
                              text: 'Go To Home Page',
                              onPressed: () => RouteService.goToHome(context)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
