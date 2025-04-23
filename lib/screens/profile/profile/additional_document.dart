import 'package:flutter/material.dart';
import 'package:synpitarn/main.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/repositories/profile_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/profile/profile/edit_information.dart';
import 'package:synpitarn/services/route_service.dart';

class AdditionalDocumentPage extends StatefulWidget {
  AdditionalDocumentPage({super.key});

  @override
  AdditionalDocumentState createState() => AdditionalDocumentState();
}

class AdditionalDocumentState extends State<AdditionalDocumentPage> {

  bool isLoading = false;

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
          'Additional Document',
          style: CustomStyle.appTitle(),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              if (isLoading)
                CustomWidget.loading()
              else
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
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

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
