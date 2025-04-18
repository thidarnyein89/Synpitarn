import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/home.dart';
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

  void _onItemTapped(int index) {
    widget.onItemTapped(index);
    setState(() { });

    if(index == AppConfig.HOME_INDEX) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    else {
      RouteService.checkLoginUserData(context);
    }
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
        BottomNavigationBarItem(icon: Icon(RemixIcons.hand_coin_line), label: "Loan"),
        BottomNavigationBarItem(icon: Icon(RemixIcons.file_copy_2_line), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
      ],
    );
  }
}
