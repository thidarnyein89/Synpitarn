import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/language.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/branch.dart';
import 'package:synpitarn/models/branch_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/branch_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:synpitarn/l10n/app_localizations.dart';

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
    setState(() {
      isLoading = true;
    });
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

    setState(() {
      isLoading = false;
    });
  }

  Future<void> openMap(double latitude, double longitude) async {
    final googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
      await launchUrl(
        Uri.parse(googleMapUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open the map.';
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
      appBar: PageAppBar(title: AppLocalizations.of(context)!.branches),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            isLoading
                ? CustomWidget.loading()
                : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: branchList?.length,
                        itemBuilder: (context, index) {
                          final branch = branchList?[index];

                          /* For Lacalization */
                          final String address;
                          final String name;

                          if (Language.currentLanguage == LanguageType.en) {
                            name = branch!.nameEn;
                          } else if (Language.currentLanguage ==
                              LanguageType.my) {
                            name = branch!.nameMm;
                          } else {
                            name = branch!.nameTh;
                          }

                          if (Language.currentLanguage == LanguageType.en) {
                            address = branch!.address;
                          } else if (Language.currentLanguage ==
                              LanguageType.my) {
                            address = branch!.addressMm;
                          } else {
                            address = branch!.addressTh;
                          }
                          /* For Lacalization */

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
                                    name,
                                    style: CustomStyle.bodyWhiteColor(),
                                  ),
                                ),
                                Container(
                                  padding: CustomStyle.pagePaddingSmall(),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: CustomStyle.primary_color,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              address,
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
                                            branch.phone,
                                            style: CustomStyle.body(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      TextButton(
                                        onPressed:
                                            () => openMap(
                                              branch.latitude,
                                              branch.longitude,
                                            ),
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.goToDirection,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2E3192),
                                          ),
                                        ),
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
