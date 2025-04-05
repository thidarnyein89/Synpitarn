import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/my_theme.dart';
import 'package:synpitarn/navigations/home_navigator.dart';
import 'package:synpitarn/navigations/profile_navigator.dart';

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

  void _onItemTapped(int index) {
    widget.onItemTapped(index);

    if(index == AppConfig.HOME_INDEX) {
      HomeNavigatorState().resetToInitialRoute();
    }
    else if(index == AppConfig.PROFILE_INDEX) {
      ProfileNavigatorState().resetToInitialRoute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: MyTheme.primary_color,
      // Active icon color
      unselectedItemColor: Colors.grey,
      // Inactive icon color
      type: BottomNavigationBarType.fixed,
      // Prevents shifting effect
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
      ],
    );
  }
}
