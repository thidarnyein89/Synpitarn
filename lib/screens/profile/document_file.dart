import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/models/document.dart';
import 'package:synpitarn/models/document_response.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/repositories/document_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/profile/register/customer_information.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:synpitarn/models/image_file.dart';

class DocumentFilePage extends StatefulWidget {
  Loan? applicationData = Loan.defaultLoan();
  List<Document>? documentList = [];

  DocumentFilePage({super.key, this.applicationData, this.documentList});

  @override
  DocumentFileState createState() => DocumentFileState();
}

class DocumentFileState extends State<DocumentFilePage> {
  final Map<String, ImageFile?> imageList = {
    'Bank Book': ImageFile(
      uniqueId: "control-281301e7-fdd5-4a66-be40-1b2debcf9697",
    ),
    'Pay Slip / Bank Transaction': ImageFile(
      uniqueId: "control-0d77d53e-7951-4bab-92d5-3cc5e5900f1e",
    ),
    'Visa': ImageFile(uniqueId: "control-44072091-4923-4eb8-ac1d-7f2be8e4155c"),
    'Passport First Page': ImageFile(
      uniqueId: "control-d3522d45-9d03-4ef8-9b88-44781291c7df",
    ),
    'Work Permit (Front)': ImageFile(
      uniqueId: "control-74593ce7-2c66-48aa-bd48-764c4bb3c165",
    ),
    'Work Permit (Back)': ImageFile(
      uniqueId: "control-fe42f126-d6f3-4970-a907-1aba299c6ba3",
    ),
  };

  final ImagePicker _picker = ImagePicker();

  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();
  List<Document> documentList = [];

  String stepName = "required_documents";
  bool isPageLoading = true;
  bool isLoading = false;
  bool isEnabled = true;

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
    loginUser = await getLoginUser();
    setState(() {});

    DefaultResponse defaultResponse = await DefaultRepository().getDefaultData(
      loginUser,
    );

    if (defaultResponse.response.code == 200) {
      defaultData = defaultResponse.data;
      setState(() {});
    } else if (defaultResponse.response.code == 403) {
      await showErrorDialog(defaultResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(defaultResponse.response.message);
    }

    if ((widget.documentList ?? []).isEmpty) {
      getUploadDocumentData();
    } else {
      showReUploadDocumentFileName();

      final Set<String> documentIds =
          widget.documentList!.map((doc) => doc.controlId).toSet();

      final List<String> keysToRemove = [];

      imageList.forEach((key, imageFile) {
        if (imageFile != null && documentIds.contains(imageFile.uniqueId)) {
          imageFile.isRequest = true;
        } else {
          keysToRemove.add(key);
        }
      });

      for (String key in keysToRemove) {
        imageList.remove(key);
      }

      isPageLoading = false;
      setState(() {});
    }
  }

  void showReUploadDocumentFileName() {
    List<Map<String, dynamic>> msg = [];

    msg.add({
      "text": "We found out that your ",
      "style": TextStyle(color: Colors.black)
    });

    final docNames = widget.documentList?.map((doc) => doc.name).toList() ?? [];
    for (int i = 0; i < docNames.length; i++) {
      msg.add({
        "text": docNames[i],
        "style": TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
      });

      if (i != docNames.length - 1) {
        msg.add({
          "text": ", ",
          "style": TextStyle(color: Colors.black)
        });
      }
    }

    msg.add({
      "text": " is blurred and we would like you to upload that document again for your loan application.",
      "style": TextStyle(color: Colors.black)
    });

    CustomWidget.showDialogWithStyle(
      context: context,
      msg: msg,
    );
  }

  Future<void> getUploadDocumentData() async {
    DocumentResponse documentResponse = await DocumentRepository()
        .getUploadDocumentData(loginUser, defaultData.versionId);

    if (documentResponse.response.code == 200) {
      documentList = documentResponse.data;

      imageList.forEach((key, imageFile) async {
        Document? document = documentList
            .where((document) => document.uniqueId == imageFile?.uniqueId)
            .firstOrNull;
        if (document != null) {
          imageFile?.isDeleteLoading = true;
          setState(() {});

          imageFile?.id = document.id;
          imageFile?.filePath = document.docUrl;
          imageFile?.isDeleteLoading = false;
          setState(() {});
        }
      });
    } else if (documentResponse.response.code == 403) {
      await showErrorDialog(documentResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(documentResponse.response.message);
    }

    isPageLoading = false;
    setState(() {});
  }

  Future<void> uploadImage(ImageFile imageFile, ImageSource imageSource) async {
    imageFile.isLoading = true;
    isEnabled = false;
    setState(() {});

    Navigator.pop(context);
    final XFile? image = await _picker.pickImage(source: imageSource);

    if (image != null) {
      File file = File(image.path);

      final Map<String, dynamic> postBody = {
        'version_id': defaultData.versionId,
        'unique_id': imageFile.uniqueId,
        'file_path': file.path,
      };

      DocumentResponse documentResponse =
          await DocumentRepository().uploadDocument(postBody, loginUser);
      if (documentResponse.response.code == 200) {
        setState(() {
          imageFile.isLoading = false;
          isEnabled = true;
          imageFile.id = documentResponse.data.firstOrNull!.id;
          imageFile.file = file;
          imageFile.filePath = file.path;
        });
      } else if (documentResponse.response.code == 403) {
        await showErrorDialog(documentResponse.response.message);
        AuthService().logout(context);
      } else {
        showErrorDialog(documentResponse.response.message);

        setState(() {
          imageFile.isLoading = false;
          isEnabled = true;
        });
      }
    } else {
      setState(() {
        imageFile.isLoading = false;
        isEnabled = true;
      });
    }
  }

  Future<void> pickImage(ImageFile imageFile) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () async {
                  uploadImage(imageFile, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  uploadImage(imageFile, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteImage(ImageFile imageFile) async {
    CustomWidget().showConfirmDialog(
      context: context,
      content: 'Are you sure to delete this image?',
      onConfirmed: () async {
        imageFile.isDeleteLoading = true;
        isEnabled = false;
        setState(() {});

        final Map<String, dynamic> postBody = {
          'id': imageFile.id,
          'unique_id': imageFile.uniqueId,
          'version_id': defaultData.versionId,
        };

        DocumentResponse documentResponse =
            await DocumentRepository().deleteDocument(postBody, loginUser);
        if (documentResponse.response.code == 200) {
          setState(() {
            imageFile.file = null;
            imageFile.filePath = null;
            imageFile.isDeleteLoading = false;
            isEnabled = true;
          });
        } else if (documentResponse.response.code == 403) {
          await showErrorDialog(documentResponse.response.message);
          AuthService().logout(context);
        } else {
          showErrorDialog(documentResponse.response.message);

          setState(() {
            imageFile.isDeleteLoading = false;
            isEnabled = true;
          });
        }
      },
    );
  }

  Future<void> handleContinue() async {
    isLoading = true;
    isEnabled = false;
    setState(() {});

    final Map<String, dynamic> postBody = {
      'version_id': defaultData.versionId,
      'input_data': jsonEncode(defaultData.inputData),
    };

    DataResponse saveResponse = await LoanRepository().saveLoanApplicationStep(
      postBody,
      loginUser,
      stepName,
    );
    if (saveResponse.response.code == 200) {
      loginUser.loanFormState = "required_documents";
      await setLoginUser(loginUser);
      isLoading = false;
      isEnabled = true;
      setState(() {});

      RouteService.profile(context);
    } else if (saveResponse.response.code == 403) {
      await showErrorDialog(saveResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(saveResponse.response.message);
    }
  }

  Future<void> handleReUpload() async {
    isLoading = true;
    isEnabled = false;
    setState(() {});

    final Map<String, dynamic> postBody = {
      'loan_application_id': widget.applicationData?.id
    };

    DocumentResponse saveResponse = await DocumentRepository()
        .saveReUploadDocumentFinish(postBody, loginUser);
    if (saveResponse.response.code == 200) {
      Navigator.of(context).pop(true);
    } else if (saveResponse.response.code == 403) {
      await showErrorDialog(saveResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(saveResponse.response.message);
    }
  }

  Widget buildUploadImageSection(String docType) {
    ImageFile? imageFile = imageList[docType];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(docType, style: CustomStyle.body()),
        CustomWidget.verticalSpacing(),
        Container(
          height: 120,
          width: double.infinity,
          color: Colors.grey[300],
          child: (imageFile?.filePath != null)
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: (imageFile?.file != null)
                          ? Image.file(imageFile!.file!)
                          : FadeInImage(
                              placeholder: AssetImage(
                                'assets/images/spinner.gif',
                              ),
                              image: NetworkImage(imageFile!.filePath!),
                              fit: BoxFit.contain,
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image),
                            ),
                    ),
                    if (imageFile.isDeleteLoading ?? false)
                      Positioned.fill(
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (!(imageFile?.isDeleteLoading ?? false))
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            deleteImage(imageFile!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : Center(child: Text('No file selected')),
        ),
        CustomWidget.verticalSpacing(),
        CustomWidget.elevatedButton(
          context: context,
          enabled: imageFile?.filePath == null,
          isLoading: imageFile!.isLoading ?? false,
          text: 'Upload',
          icon: Icons.image_outlined,
          onPressed: () => pickImage(imageFile),
        ),
        CustomWidget.verticalSpacing(),
      ],
    );
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
      appBar: PageAppBar(
        title: (loginUser.loanApplicationSubmitted)
            ? 'Documents'
            : 'Required Documents',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              if (isPageLoading)
                CustomWidget.loading()
              else
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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
                                ...imageList.keys
                                    .map(
                                      (docType) =>
                                          buildUploadImageSection(docType),
                                    )
                                    .toList(),
                                CustomWidget.verticalSpacing(),
                                createButtonSection(),
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

  Widget createButtonSection() {
    if (!loginUser.loanApplicationSubmitted && (widget.documentList ?? []).isEmpty) {
      return Row(
        children: [
          Expanded(
            child: CustomWidget.elevatedButton(
              context: context,
              enabled: true,
              isLoading: false,
              text: 'Previous',
              onPressed: handlePrevious,
            ),
          ),
          CustomWidget.horizontalSpacing(),
          Expanded(
            child: CustomWidget.elevatedButton(
              context: context,
              enabled: isEnabled,
              isLoading: isLoading,
              text: 'Continue',
              onPressed: handleContinue,
            ),
          ),
        ],
      );
    }

    if ((widget.documentList ?? []).isNotEmpty) {
      final bool allFilesHavePath = imageList.values
          .whereType<ImageFile>()
          .every((file) => file.filePath != null);

      return CustomWidget.elevatedButton(
        context: context,
        enabled: allFilesHavePath,
        isLoading: isLoading,
        text: 'Reupload Request',
        onPressed: handleReUpload,
      );
    }

    return Container();
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(
      context: context,
      msg: errorMessage,
    );
  }
}
