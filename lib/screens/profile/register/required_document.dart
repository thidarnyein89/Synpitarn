import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/models/document.dart';
import 'package:synpitarn/models/document_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/repositories/document_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/profile/register/customer_information.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:synpitarn/models/image_file.dart';

class RequiredDocumentPage extends StatefulWidget {
  const RequiredDocumentPage({super.key});

  @override
  RequiredDocumentState createState() => RequiredDocumentState();
}

class RequiredDocumentState extends State<RequiredDocumentPage> {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();

  String stepName = "required_documents";
  bool isLoading = false;
  bool isEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> handleContinue() async {
    isLoading = true;
    isEnabled = false;
    setState(() {});

    final Map<String, dynamic> postBody = {
      'version_id': defaultData.versionId,
      'input_data': jsonEncode(defaultData.inputData),
    };

    DataResponse saveResponse = await LoanRepository()
        .saveLoanApplicationStep(postBody, loginUser, stepName);
    if (saveResponse.response.code != 200) {
      showErrorDialog(saveResponse.response.message);
    } else {
      loginUser.loanFormState = "required_documents";
      await setLoginUser(loginUser);
      isLoading = false;
      isEnabled = true;
      setState(() {});

      RouteService.profile(context);
    }
  }

  void handlePrevious() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerInformationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Required Documents'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegisterTabBar(activeStep: 1),
                    Padding(
                      padding: CustomStyle.pageWithoutTopPadding(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget.verticalSpacing(),
                          Row(
                            children: [
                              Expanded(
                                child: CustomWidget.elevatedButton(
                                  enabled: true,
                                  isLoading: false,
                                  text: 'Previous',
                                  onPressed: handlePrevious,
                                ),
                              ),
                              CustomWidget.horizontalSpacing(),
                              Expanded(
                                child: CustomWidget.elevatedButton(
                                  enabled: isEnabled,
                                  isLoading: isLoading,
                                  text: 'Continue',
                                  onPressed: handleContinue,
                                ),
                              ),
                            ],
                          )
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
    );
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
  }
}
