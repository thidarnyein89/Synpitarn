import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/branch.dart';
import 'package:synpitarn/models/branch_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/branch_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/main_app_bar.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/common_service.dart';

class BranchPage extends StatefulWidget {
  const BranchPage({super.key});

  @override
  BranchState createState() => BranchState();
}

class BranchState extends State<BranchPage> {
  User loginUser = User.defaultUser();
  List<Branch>? branchList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  Future<void> getInitData() async {
    isLoading = true;
    loginUser = await getLoginUser();
    await getBranches();

    isLoading = false;
    setState(() {});
  }

  Future<void> getBranches() async {
    BranchResponse branchResponse = await BranchRepository().getBranches();

    if (branchResponse.response.code == 200) {
      branchList = branchResponse.data;
      print(branchList?.map((branch) => branch.address));
      setState(() {});
    } else if (branchResponse.response.code == 403) {
      await showErrorDialog(branchResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(branchResponse.response.message);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(
      context: context,
      msg: errorMessage,
    );
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: "Branches"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: branchList?.length,
                itemBuilder: (context, index) {
                  final branch = branchList?[index];
                  return Card(
                    elevation: 1,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: CustomStyle.pagePaddingSmall(),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CustomStyle.primary_color,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Branch ${index + 1}',
                            style: CustomStyle.bodyWhiteColor(),
                          ),
                        ),
                        Container(
                          padding: CustomStyle.pagePaddingSmall(),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: CustomStyle.primary_color,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      branch!.address,
                                      style: CustomStyle.body(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: CustomStyle.primary_color,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    branch!.phone,
                                    style: CustomStyle.body(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              CustomWidget.elevatedButtonOutline(
                                context: context,
                                onPressed: () {},
                                text: 'Go To Direction',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
