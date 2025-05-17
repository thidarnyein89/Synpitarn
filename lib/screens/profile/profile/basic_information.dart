import 'package:flutter/material.dart';
import 'package:synpitarn/main.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/repositories/profile_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/profile/profile/edit_information.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BasicInformationPage extends StatefulWidget {
  BasicInformationPage({super.key});

  @override
  BasicInformationState createState() => BasicInformationState();
}

class BasicInformationState extends State<BasicInformationPage>
    with RouteAware {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
      getProfileData();
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> getProfileData() async {
    isLoading = true;
    setState(() {});

    loginUser = await getLoginUser();

    UserResponse profileResponse =
        await ProfileRepository().getProfile(loginUser);
    if (profileResponse.response.code == 200) {
      loginUser = profileResponse.data;
    } else if (profileResponse.response.code == 403) {
      await showErrorDialog(profileResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(profileResponse.response.message);
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(
        context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  void handleEdit() {
    RouteService.goToNavigator(
        context,
        EditInformationPage(
          editUser: loginUser,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: AppLocalizations.of(context)!.basicInformation),
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
                                CustomWidget.buildRow(
                                  AppLocalizations.of(context)!.name,
                                  loginUser.name,
                                ),
                                CustomWidget.buildRow(
                                  AppLocalizations.of(context)!.phoneNumber,
                                  loginUser.phoneNumber,
                                ),
                                CustomWidget.buildRow(
                                  AppLocalizations.of(context)!.dob,
                                  loginUser.dob,
                                ),
                                CustomWidget.buildRow(
                                  AppLocalizations.of(context)!.provinceWork,
                                  loginUser.provinceOfWorkText,
                                ),
                                CustomWidget.buildRow(
                                  AppLocalizations.of(context)!
                                      .provinceResidence,
                                  loginUser.provinceOfResidentText,
                                ),
                                CustomWidget.buildRow(
                                  AppLocalizations.of(context)!.incomeType,
                                  loginUser.incomeType,
                                ),
                                CustomWidget.buildRow(
                                  AppLocalizations.of(context)!.nrcNumber,
                                  loginUser.identityNumber,
                                ),
                                CustomWidget.buildRow(
                                  AppLocalizations.of(context)!.passport,
                                  loginUser.passport,
                                ),
                                CustomWidget.buildRow(
                                  AppLocalizations.of(context)!.salary,
                                  CommonService.formatWithThousandSeparator(
                                      context, loginUser.salary),
                                ),
                                CustomWidget.verticalSpacing(),
                                CustomWidget.elevatedButton(
                                  context: context,
                                  text: AppLocalizations.of(context)!
                                      .editInformationButton,
                                  onPressed: handleEdit,
                                ),
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
