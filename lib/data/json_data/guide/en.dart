import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/json_data/common.dart';

class GuideEnglish {
  static List<List<ContentBlock>> allContent = [
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Click '),
        Data(text: 'link', url: AppConfig.WEB_URL, style: CustomStyle.linkStyle()),
        Data(text: ' to register'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'You will be sent an OTP to the registered mobile number'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(
            text:
                'Create an account – for this you will need to set a pin code. This will be a 6 digit number that you can remember.'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(
            text:
                'Your mobile phone number is automatically set as your username'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(
            text:
                'Once you have created the account you need to provide us with information in the form on your phone'),
      ]),
      ContentBlock.text(paddingLeft: 10, [
        Data(text: '- '),
        Data(
            text:
                'After you have finished filling in the form you will need to upload documents by taking a picture of some documents such as your pink card and pay slip'),
      ]),
      ContentBlock.text(paddingLeft: 10, [
        Data(text: '- '),
        Data(text: 'Work Permit Document: Pink Card or MOU'),
      ]),
      ContentBlock.text(paddingLeft: 10, [
        Data(text: '- '),
        Data(text: 'NRC or Passport'),
      ]),
      ContentBlock.text(paddingLeft: 10, [
        Data(text: '- '),
        Data(text: 'Payslip or Bank Book'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'We suggest you prepare these before completing the form'),
      ]),
    ],
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'After we have received your loan application our Myanmar loan officer will speak with you'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'This will be done on your phone and will take around 20 minutes'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'You will need to select a convenient time to speak to our staff'),
      ]),
    ],
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'When your loan is approved you will need to visit our branch to complete the process'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Please book a time convenient to you'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'This is only required for the first loan or if you have not borrowed for more than 6 months.'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'For you second loan everything can be done through your mobile phone'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'We have convenient opening hours including weekends and evenings'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Your loan will be transferred to your bank account on the same day that you sign your loan agreement.'),
      ]),
    ]
  ];
}
