import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/models/document.dart';
import 'package:synpitarn/models/document_response.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_application_response.dart';
import 'package:synpitarn/repositories/document_repository.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';

class AdditionalDocumentPage extends StatefulWidget {
  const AdditionalDocumentPage({super.key});

  @override
  AdditionalDocumentState createState() => AdditionalDocumentState();
}

class AdditionalDocumentState extends State<AdditionalDocumentPage> {
  Loan applicationData = Loan.defaultLoan();
  User loginUser = User.defaultUser();
  List<Document> documentList = [];
  bool isLoading = false;
  late PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getInitData();
    _pageController = PageController();
  }

  Future<void> getInitData() async {
    isLoading = true;
    loginUser = await getLoginUser();
    if (mounted) {
      setState(() {});
    }

    await getApplicationData();
    await getAdditionalDocumentData();

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getApplicationData() async {
    LoanApplicationResponse applicationResponse = await LoanRepository()
        .getApplication(loginUser);

    if (applicationResponse.response.code != 200) {
      showErrorDialog(applicationResponse.response.message);
    } else {
      applicationData = applicationResponse.data;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> getAdditionalDocumentData() async {
    DocumentResponse documentResponse = await DocumentRepository()
        .getAdditionalDocumentData(loginUser, applicationData.id);

    if (documentResponse.response.code == 200) {
      documentList = documentResponse.data;
    }

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  void onThumbnailTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Additional Document'),
      body: SafeArea(
        child:
            isLoading
                ? CustomWidget.loading()
                : documentList.isEmpty
                ? Center(
                  child: Text(
                    'There is no additional documents.',
                    style: CustomStyle.bodyGreyColor(),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Spacer(),
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: documentList.length,
                          onPageChanged: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
                              documentList[index].file,
                              fit: BoxFit.contain,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: documentList.length,
                          itemBuilder: (context, index) {
                            final doc = documentList[index];
                            return GestureDetector(
                              onTap: () => onThumbnailTap(index),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                padding:
                                    selectedIndex == index
                                        ? const EdgeInsets.all(2)
                                        : EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  border:
                                      selectedIndex == index
                                          ? Border.all(
                                            color: Colors.blue,
                                            width: 2,
                                          )
                                          : null,
                                ),
                                child: Image.network(
                                  doc.file,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
      ),
    );
  }
}
