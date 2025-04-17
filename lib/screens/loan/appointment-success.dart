import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/repositories/data_repository.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/profile/information2.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';

class AppointmentSuccessPage extends StatefulWidget {
  const AppointmentSuccessPage({super.key});

  @override
  AppointmentSuccessState createState() => AppointmentSuccessState();
}

class AppointmentSuccessState extends State<AppointmentSuccessPage> {
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
        appBar: AppBar(
          backgroundColor: CustomStyle.primary_color,
          title: Text(
            'Appointment Success',
            style: CustomStyle.appTitle(),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
        ),
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
