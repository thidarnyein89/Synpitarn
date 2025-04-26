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
import 'package:synpitarn/services/route_service.dart';

class BasicInformationPage extends StatefulWidget {
  BasicInformationPage({super.key});

  @override
  BasicInformationState createState() => BasicInformationState();
}

class BasicInformationState extends State<BasicInformationPage> with RouteAware {
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

    UserResponse profileResponse = await ProfileRepository().getProfile(loginUser);
    if(profileResponse.response.code != 200) {
      showErrorDialog(profileResponse.response.message);
    }
    else {
      loginUser = profileResponse.data;
    }

    isLoading = false;
    setState(() {});
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  void handleEdit() {
    RouteService.goToNavigator(context, EditInformationPage(editUser: loginUser,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Basic Information'),
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
                                  "Name",
                                  loginUser.name,
                                ),
                                CustomWidget.buildRow(
                                  "Phone Number",
                                  loginUser.phoneNumber,
                                ),
                                CustomWidget.buildRow(
                                  "Date of Birth",
                                  loginUser.dob,
                                ),
                                CustomWidget.buildRow(
                                  "Province of Work",
                                  loginUser.provinceOfWorkText,
                                ),
                                CustomWidget.buildRow(
                                  "Province of Residence",
                                  loginUser.provinceOfResidentText,
                                ),
                                CustomWidget.buildRow(
                                  "How often are you paid",
                                  loginUser.incomeType,
                                ),
                                CustomWidget.buildRow(
                                  "Identity Number",
                                  loginUser.identityNumber,
                                ),
                                CustomWidget.buildRow(
                                  "Passport",
                                  loginUser.passport,
                                ),
                                CustomWidget.buildRow(
                                  "Total income (Salary + Overtime + Other Income) (Baht)",
                                  "${loginUser.salary} Baht",
                                ),
                                CustomWidget.elevatedButton(
                                  text: 'Edit Information',
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
