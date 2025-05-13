import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/json_data/about_us/en.dart';
import 'package:synpitarn/data/json_data/about_us/mm.dart';
import 'package:synpitarn/data/json_data/about_us/th.dart';
import 'package:synpitarn/data/json_data/common.dart';
import 'package:synpitarn/data/language.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/models/aboutUs.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  List<double> contentHeight = [];
  List<List<ContentBlock>> allContent = [];

  double containerHeight = 150;

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getInitData() async {

    if (Language.currentLanguage == LanguageType.en) {
      allContent = AboutUsEnglish.allContent;
    }
    else if(Language.currentLanguage == LanguageType.my) {
      allContent = AboutUsMyanmar.allContent;
    }
    else if(Language.currentLanguage == LanguageType.th) {
      allContent = AboutUsThai.allContent;
    }

    aboutList = await _commonService.readAboutUsData();

    //For Remove FAQ, Announcement Data
    aboutList =
        aboutList.where((aboutData) {
          return aboutData.isAboutUs;
        }).toList();

    contentHeight = List.generate(aboutList.length, (index) => 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: AppLocalizations.of(context)!.getToKnowUs),
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
    );
  }

  Widget _buildCard(int index) {
    GlobalKey contentKey = GlobalKey();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = contentKey.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final newHeight = box.size.height;

          if (contentHeight[index] != newHeight) {
            setState(() {
              contentHeight[index] = newHeight;
            });
          }
        }
      }

      if(widget.activeIndex > 0) {
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
                    Text(aboutList[index].getTitle(), style: CustomStyle.subTitle()),
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
          child: Column(
            key: contentKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget.verticalSpacing(),
              ...allContent[index].map((block) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: block.paddingLeft!.toDouble(),
                    bottom: 20,
                  ),
                  child: buildTextSpan(context, block.textData!),
                );
              }),
            ],
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
          contentHeight[i] +
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

  RichText buildTextSpan(BuildContext context, List<Data> dataList) {
    return RichText(
      text: TextSpan(
        children: dataList.map((data) {
          if (data.url != null) {
            return TextSpan(
              style: data.style,
              text: data.text,
              recognizer: TapGestureRecognizer()..onTap = () async {
                showScaffoldMessenger(AppLocalizations.of(context)!.downloading);

                try {
                  FileDownloader.downloadFile(
                    url: data.url!,
                    name: 'license.pdf',
                    onDownloadCompleted: (path) {
                      showScaffoldMessenger(AppLocalizations.of(context)!.downloadComplete);
                    },
                    onDownloadError: (errorMessage) {
                      showScaffoldMessenger("Error downloading: $errorMessage");
                    },
                  );
                } catch (e) {
                  showScaffoldMessenger("Error downloading");
                }
              },
            );
          } else {
            return TextSpan(
              style: data.style ?? CustomStyle.body(),
              text: data.text,
            );
          }
        }).toList(),
      ),
    );
  }

  void showScaffoldMessenger(String downloadMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(downloadMessage),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
