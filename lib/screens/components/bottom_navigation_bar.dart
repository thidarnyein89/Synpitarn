import 'package:flutter/material.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/screens/loan/loan_history.dart';
import 'package:synpitarn/screens/profile/profile_home.dart';
import 'package:synpitarn/screens/setting/setting.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:remixicon/remixicon.dart';
import 'package:synpitarn/l10n/app_localizations.dart';

class CustomBottomNavigationBar extends StatefulWidget
    implements PreferredSizeWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onItemTapped(int index) async {
    if (index == widget.selectedIndex) return;

    User loginUser = await getLoginUser();

    widget.onItemTapped(index);
    setState(() {});

    if (index == ConstantData.HOME_INDEX) {
      RouteService.goToReplaceNavigator(context, HomePage());
    } else if (index == ConstantData.LOAN_INDEX) {
      if (!loginUser.loanApplicationSubmitted) {
        showErrorDialog(AppLocalizations.of(context)!.noApplyLoan);
      } else {
        RouteService.goToReplaceNavigator(context, LoanHistoryPage());
      }
    } else if (index == ConstantData.PROFILE_INDEX) {
      RouteService.goToReplaceNavigator(context, ProfileHomePage());
    } else if (index == ConstantData.SETTING_INDEX) {
      RouteService.goToReplaceNavigator(context, SettingPage());
    }
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: CustomStyle.primary_color,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(RemixIcons.hand_coin_line),
          label: AppLocalizations.of(context)!.loan,
        ),
        BottomNavigationBarItem(
          icon: Icon(RemixIcons.file_copy_2_line),
          label: AppLocalizations.of(context)!.profile,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: AppLocalizations.of(context)!.setting,
        ),
      ],
    );
  }
}
