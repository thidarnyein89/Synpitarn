import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        appBar: PageAppBar(
            title: AppLocalizations.of(context)!.applyLoan("")),
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
                            AppLocalizations.of(context)!.appointmentSuccess1,
                            style: CustomStyle.subTitleBold(),
                          ),
                          CustomWidget.verticalSpacing(),
                          CustomWidget.verticalSpacing(),
                          Text(
                            AppLocalizations.of(context)!.appointmentSuccess2,
                            style: CustomStyle.body(),
                          ),
                          CustomWidget.verticalSpacing(),
                          CustomWidget.elevatedButton(
                              context: context,
                              enabled: true,
                              isLoading: false,
                              text: AppLocalizations.of(context)!.goToHomePage,
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
