import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/language.dart';
import 'package:synpitarn/data/shared_rsa_value.dart';
import 'package:synpitarn/main.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/location/branch.dart';
import 'package:synpitarn/screens/profile/profile/map_screen.dart';
import 'package:synpitarn/screens/setting/about_us.dart';
import 'package:synpitarn/screens/setting/call_center.dart';
import 'package:synpitarn/screens/setting/guide.dart';
import 'package:synpitarn/screens/videocall/admin_screen.dart';
import 'package:synpitarn/screens/videocall/video_call_screen.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:synpitarn/l10n/app_localizations.dart';
import 'package:synpitarn/screens/auth/biometric_helper.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<SettingPage> {
  User loginUser = User.defaultUser();
  late PackageInfo packageInfo;

  bool biometricEnabled = false;
  bool isPageLoading = true;

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getInitData() async {
    isPageLoading = true;
    setState(() {});

    loginUser = await getLoginUser();
    packageInfo = await PackageInfo.fromPlatform();

    bool needBiometricLogin = await getNeedBiometricLogin();
    String biometricUserID = await getBiometricUserID();
    if (needBiometricLogin && biometricUserID == loginUser.id.toString()) {
      biometricEnabled = true;
    } else {
      biometricEnabled = false;
    }

    isPageLoading = false;
    setState(() {});
  }

  Future<void> handleLogout() async {
    await FirebaseMessaging.instance.deleteToken();
    AuthService().logout(context);
  }

  Widget createUserInfoSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          child: Icon(Icons.person, color: Colors.white, size: 40),
        ),
        CustomWidget.horizontalSpacing(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              if (loginUser.name != "")
                Text(
                  loginUser.name,
                  style: CustomStyle.bodyBold(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              Text(
                loginUser.phoneNumber,
                style: CustomStyle.body(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget createSettingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget.verticalSpacing(),
        Text(
          AppLocalizations.of(context)!.setting,
          style: CustomStyle.subTitleBold(),
        ),
        CustomWidget.verticalSmallSpacing(),
        buildSettingTile(
          Icons.language,
          AppLocalizations.of(context)!.changeLanguage,
          showLanguageDialog,
        ),
        createBiometricSetting(),
      ],
    );
  }

  Widget createLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget.verticalSpacing(),
        Text(
          AppLocalizations.of(context)!.location,
          style: CustomStyle.subTitleBold(),
        ),
        CustomWidget.verticalSmallSpacing(),
        buildSettingTile(
          Icons.apartment,
          AppLocalizations.of(context)!.nearestBranch,
          goToBranchPage,
        ),
        buildSettingTile(
          Icons.money,
          AppLocalizations.of(context)!.nearestATM,
          goToMapScreen,
        ),
      ],
    );
  }

  Widget createVcallSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSettingTile(
          Icons.video_call,
          'Video Call',
          () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminScreen()),
            ),
          },
        ),
      ],
    );
  }

  Widget createHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget.verticalSpacing(),
        Text(
          AppLocalizations.of(context)!.helpAndSupport,
          style: CustomStyle.subTitleBold(),
        ),
        CustomWidget.verticalSmallSpacing(),
        buildSettingTile(
          Icons.help_outline,
          AppLocalizations.of(context)!.howToApplyLoan,
          goToGuidePage,
        ),
        buildSettingTile(
          Icons.info_outline,
          AppLocalizations.of(context)!.getToKnowUs,
          goToAboutUsPage,
        ),
        buildSettingTile(
          Icons.support_agent,
          AppLocalizations.of(context)!.callCenter,
          goToCallCenterPage,
        ),
      ],
    );
  }

  void goToGuidePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GuidePage(activeStep: 0)),
    );
  }

  void goToAboutUsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutUsPage(activeIndex: 0)),
    );
  }

  void goToCallCenterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CallCenterPage()),
    );
  }

  void goToMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
  }

  Future<void> showLanguageDialog() async {
    final currentLocale = Localizations.localeOf(context);

    var result = await showModalBottomSheet<Language>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: LanguageData.languages.length,
            itemBuilder: (context, index) {
              final lang = LanguageData.languages[index];
              return ListTile(
                leading: ClipOval(
                  child: Image.asset(
                    lang.image,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(lang.label),
                trailing:
                    lang.locale == currentLocale
                        ? const Icon(
                          Icons.check,
                          color: CustomStyle.primary_color,
                        )
                        : null,
                onTap: () {
                  MyApp.setLocale(context, lang.locale);
                  Navigator.pop(context, lang);
                },
              );
            },
          ),
        );
      },
    );
  }

  void goToBranchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BranchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: AppLocalizations.of(context)!.setting),
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
                    child: Padding(
                      padding: CustomStyle.pagePadding(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          createUserInfoSection(),
                          createSettingSection(),
                          createVcallSection(),
                          createLocationSection(),
                          createHelpSection(),
                          CustomWidget.verticalSpacing(),
                          CustomWidget.elevatedButton(
                            context: context,
                            text: AppLocalizations.of(context)!.logout,
                            onPressed: handleLogout,
                          ),
                          CustomWidget.verticalSpacing(),
                          Center(child: Text("v ${packageInfo.version}")),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: ConstantData.SETTING_INDEX,
        onItemTapped: (index) {
          setState(() {
            ConstantData.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }

  Widget buildSettingTile(IconData icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 16),
            Expanded(child: Text(title)),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget createBiometricSetting() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(Icons.fingerprint_outlined, size: 24),
          SizedBox(width: 16),
          Expanded(child: Text(AppLocalizations.of(context)!.biometric)),
          SwitchTheme(
            data: SwitchThemeData(
              trackOutlineColor: WidgetStatePropertyAll(
                biometricEnabled ? CustomStyle.primary_color : Colors.grey,
              ),
            ),
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: biometricEnabled,
                onChanged: (value) async {
                  setState(() {
                    biometricEnabled = value;
                  });

                  await removeBiometricUserID();
                  await removeBiometricUUID();
                  if (biometricEnabled) {
                    await setNeedBiometricLogin(true);
                    createBiometricDialog(context);
                  } else {
                    await setNeedBiometricLogin(false);
                  }
                },
                activeTrackColor: CustomStyle.primary_color,
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
