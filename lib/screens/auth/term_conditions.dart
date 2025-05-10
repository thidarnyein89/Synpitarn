import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/data/term_condition/common.dart';
import 'package:synpitarn/data/term_condition/en.dart';
import 'package:synpitarn/data/term_condition/mm.dart';
import 'package:synpitarn/data/term_condition/th.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class TermAndConditionsPage extends StatefulWidget {
  const TermAndConditionsPage({super.key});

  @override
  TermAndConditionsState createState() => TermAndConditionsState();
}

class TermAndConditionsState extends State<TermAndConditionsPage> {

  List<ContentBlock> allContent = [];

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getInitData() async {
     String currentLanguage = await getLanguage();

     if(currentLanguage == 'en') {
       allContent = TermConditionEnglish.allContent;
     }
     else if(currentLanguage == 'my') {
       allContent = TermConditionMyanmar.allContent;
     }
     else if(currentLanguage == 'th') {
       allContent = TermConditionThai.allContent;
     }

     setState(() { });
  }

  RichText buildTextSpan(BuildContext context, List<Data> data) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
        children: data.map((span) {
          if (span.url != null) {
            return TextSpan(
              text: span.text,
              style: span.style,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri uri = Uri.parse(span.url!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
            );
          }
          else if (span.phoneNumber != null) {
            return TextSpan(
              text: span.text,
              style: span.style,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  _callNow(span.phoneNumber);
                },
            );
          }
          else {
            return TextSpan(text: span.text, style: span.style);
          }
        }).toList(),
      ),
    );
  }

  TableCell buildRichTextCell(BuildContext context, List<Data> data) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
            children: data
                .map((span) => TextSpan(text: span.text, style: span.style))
                .toList(),
          ),
        ),
      ),
    );
  }

  TableRow buildTableRow(List<Widget> cells) {
    return TableRow(
      children: cells,
    );
  }

  Future<void> _callNow(String? phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');

    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      debugPrint('Cannot launch phone dialer');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomStyle.primary_color,
        title: Text(
          AppLocalizations.of(context)!.termCondition,
          style: CustomStyle.appTitle(),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...allContent.map((block) {
              if (block.type == ContentType.text && block.textData != null) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: block.paddingLeft!.toDouble(),
                    bottom: 16,
                  ),
                  child: buildTextSpan(context, block.textData!),
                );
              } else if (block.type == ContentType.table &&
                  block.tableData != null) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey, width: 1),
                    children: block.tableData!.map((item) {
                      return buildTableRow([
                        buildRichTextCell(context, item['type']!),
                        buildRichTextCell(context, item['period']!),
                      ]);
                    }).toList(),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
            CustomWidget.verticalSpacing(),
            CustomWidget.elevatedButton(
              context: context,
              text: AppLocalizations.of(context)!.agreeTermCondition,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        ),
      ),
    );
  }
}
