import 'package:flutter/material.dart';
import 'package:synpitarn/models/document.dart';
import 'package:synpitarn/models/document_response.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_application_response.dart';
import 'package:synpitarn/repositories/document_repository.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';

class AdditionalDocumentPage extends StatefulWidget {
  AdditionalDocumentPage({super.key});

  @override
  AdditionalDocumentState createState() => AdditionalDocumentState();
}

class AdditionalDocumentState extends State<AdditionalDocumentPage> {
  Loan applicationData = Loan.defaultLoan();
  User loginUser = User.defaultUser();
  List<Document> documentList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  Future<void> getInitData() async {
    isLoading = true;
    loginUser = await getLoginUser();
    setState(() {});

    await getApplicationData();
    await getAdditionalDocumentData();

    isLoading = false;
    setState(() {});
  }

  Future<void> getApplicationData() async {
    LoanApplicationResponse applicationResponse = await LoanRepository()
        .getApplication(loginUser);

    if (applicationResponse.response.code != 200) {
      showErrorDialog(applicationResponse.response.message);
    } else {
      applicationData = applicationResponse.data;
      setState(() {});
    }
  }

  Future<void> getAdditionalDocumentData() async {
    DocumentResponse documentResponse = await DocumentRepository()
        .getAdditionalDocumentData(loginUser, applicationData.id);

    if (documentResponse.response.code == 200) {
      documentList = documentResponse.data;
      print(documentList.map((data) => data.docName));
    }

    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Additional Document'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              if (isLoading)
                CustomWidget.loading()
              else
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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
                                // Image.network(documentList.data)
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
