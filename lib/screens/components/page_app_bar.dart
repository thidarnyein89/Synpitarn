import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';

class PageAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? title = "";

  PageAppBar({super.key, required this.title});

  @override
  PageAppBarState createState() => PageAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class PageAppBarState extends State<PageAppBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomStyle.primary_color,
      title: Text(
        widget.title!,
        style: CustomStyle.appTitle(),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      automaticallyImplyLeading: true,
    );
  }
}
