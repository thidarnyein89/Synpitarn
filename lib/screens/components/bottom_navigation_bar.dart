import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/screens/loan/loan_history.dart';
import 'package:synpitarn/screens/loan/loan_status.dart';
import 'package:synpitarn/screens/profile/profile_home.dart';
import 'package:synpitarn/screens/setting/setting.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:remixicon/remixicon.dart';

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
    User loginUser = await getLoginUser();

    widget.onItemTapped(index);
    setState(() {});

    if (index == AppConfig.HOME_INDEX) {
      RouteService.goToReplaceNavigator(context, HomePage());
    } else if (index == AppConfig.LOAN_INDEX) {
      if(!loginUser.loanApplicationSubmitted) {
        showErrorDialog(AppConfig.NO_CURRENT_LOAN);
      }
      else {
        RouteService.goToReplaceNavigator(context, LoanHistoryPage());
      }
    } else if (index == AppConfig.PROFILE_INDEX) {
      RouteService.goToReplaceNavigator(context, ProfileHomePage());
    }
    else if (index == AppConfig.SETTING_INDEX) {
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
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(RemixIcons.hand_coin_line), label: "Loan"),
        BottomNavigationBarItem(
            icon: Icon(RemixIcons.file_copy_2_line), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
      ],
    );
  }
}
