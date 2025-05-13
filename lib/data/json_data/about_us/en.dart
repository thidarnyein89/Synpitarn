import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/json_data/common.dart';

class AboutUsEnglish {
  static List<List<ContentBlock>> allContent = [
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'We are a Thai pico finance company that focuses on lending to individuals'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Licensed by the Thai Ministry of Finance to operate in Pathumthani'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'License number [('),
        Data(text: 'Click Here', url: 'https://synpitarn.com/assets/Pico_license_SPTP.pdf', style: CustomStyle.linkStyle()),
        Data(text: ')]'),
      ]),
    ],
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Our maximum interest rate of 3% per month is set by the Ministry of Finance'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Minimum term is 2 months'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Your first loan will be a maximum of Baht 5,000. With good repayment history this amount can be increased and the terms can be longer.'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Repayments must be made every 2 weeks'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'We lend between Baht 3,000 and Baht 25,000 with loan terms tailored to meet your ability'),
      ]),
      ContentBlock.text([
        Data(text: 'Example: a Baht 10,000 loan with a 2 months term will be 4 repayments of Baht 2,593.14'),
      ]),
    ],
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Convenient'),
      ]),
      ContentBlock.text([
        Data(text: '  '),
        Data(text: 'You can access us in  Myanmar language from your mobile phone at a time convenient to you'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Regulated'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Transparent'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Confidential'),
      ]),
    ],
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'At least 20 years old'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Have been living in Thailand for at least 2 years and working in the current company for at least 1 year'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Work or live in Pathumthani'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Have a valid pink card or work permit'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Have a Thai bank account'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'Have a smart phone'),
      ]),
    ]
  ];
}
