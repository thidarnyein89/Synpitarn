import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/custom_widget.dart';
import 'package:synpitarn/models/aboutUs.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/data/app_config.dart';

class AboutUsPage extends StatefulWidget {
  int activeIndex;

  AboutUsPage({super.key, required this.activeIndex});

  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends State<AboutUsPage> {
  final CommonService _commonService = CommonService();
  ScrollController _scrollController = ScrollController();

  List<AboutUS> aboutList = [];
  List<double> _htmlHeight = [];

  double containerHeight = 150;

  @override
  void initState() {
    super.initState();
    readAboutUsData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> readAboutUsData() async {
    aboutList = await _commonService.readAboutUsData();

    //For Remove FAQ, Announcement Data
    aboutList =
        aboutList.where((aboutData) {
          return aboutData.descriptionEN.isNotEmpty;
        }).toList();

    _htmlHeight = List.generate(aboutList.length, (index) => 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: CustomStyle.pagePadding(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        aboutList
                            .asMap()
                            .map((index, aboutData) {
                              return MapEntry(index, _buildCard(index));
                            })
                            .values
                            .toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: AppConfig.CURRENT_INDEX,
        onItemTapped: (index) {
          setState(() {
            AppConfig.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }

  Widget _buildCard(int index) {
    GlobalKey htmlKey = GlobalKey();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = htmlKey.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final newHeight = box.size.height;

          if (_htmlHeight[index] != newHeight) {
            _htmlHeight[index] = newHeight;
            setState(() {});
          }
        }
      }

      if (widget.activeIndex == index) {
        _scrollToStep(widget.activeIndex);
      }
    });

    return Column(
      children: [
        Container(
          height: containerHeight,
          decoration: BoxDecoration(color: CustomStyle.secondary_color),
          child: Stack(
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomWidget.horizontalSpacing(),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(
                        aboutList[index].icon,
                        color: CustomStyle.icon_color,
                      ),
                    ),
                    CustomWidget.horizontalSpacing(),
                    Text(aboutList[index].titleEN, style: CustomStyle.subTitle()),
                  ],
                ),
              ),
              Positioned(
                top: -24,
                left: MediaQuery.of(context).size.width / 2 - 44,
                child: CircleAvatar(radius: 24, backgroundColor: Colors.white),
              ),
            ],
          ),
        ),
        CustomWidget.verticalSpacing(),
        Container(
          padding: EdgeInsets.zero, // Adjust padding as needed
          child: Html(
            key: htmlKey,
            data: aboutList[index].descriptionEN,
            style: {
              "ul": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
              "li": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.only(left: 0),
              ),
            },
          ),
        ),
        CustomWidget.verticalSpacing(),
      ],
    );
  }

  void _scrollToStep(int index) {
    double position = 0.0;

    for (var i = 0; i < index; i++) {
      position +=
          _htmlHeight[i] +
          containerHeight +
          CustomWidget.verticalSpacing().height!.toInt() +
          CustomWidget.verticalSpacing().height!.toInt();
    }

    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
