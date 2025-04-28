import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    }

    isLoading = false;
    setState(() {});
  }

  Map<String, List<Document>> groupImagesByDate(List<Document> images) {
    Map<String, List<Document>> groupedImages = {};

    for (var item in images) {
      String formattedDate = getFormattedDate(item.createdAt);

      if (groupedImages.containsKey(formattedDate)) {
        groupedImages[formattedDate]!.add(item);
      } else {
        groupedImages[formattedDate] = [item];
      }
    }

    return groupedImages;
  }

  String getFormattedDate(String createdAt) {
    // Parse the created_at date string
    DateTime createdDate = DateTime.parse(createdAt);
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    // Compare with Today, Yesterday, or specific date
    if (isSameDay(createdDate, now)) {
      return 'Today';
    } else if (isSameDay(createdDate, yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat(
        'd MMM yyyy',
      ).format(createdDate); // Example: 23 Apr 2025
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
    Map<String, List<Document>> groupedImages = groupImagesByDate(documentList);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Additional Document'),
      body: Stack(
        children: [
          if (isLoading)
            CustomWidget.loading()
          else
            groupedImages.isEmpty
                ? Center(
                  child: Text(
                    'No Data Available',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                )
                : ListView(
                  children:
                      groupedImages.entries.map((entry) {
                        String date = entry.key;
                        List<Document> imageItems = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            ...imageItems.map((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  child: Image.network(
                                    'item.file',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress,
                                    ) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null
                                                    : null,
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                          child: Icon(Icons.broken_image),
                                        ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                ),
        ],
      ),
    );
  }
}
