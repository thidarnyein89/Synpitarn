import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/json_data/common.dart';

class GuideThai {
  static List<List<ContentBlock>> allContent = [
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'คลิกที่นี่เพื่อลงทะเบียน', url: AppConfig.WEB_URL, style: CustomStyle.linkStyle()),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'คุณจะได้รับรหัสผ่านแบบใช้ครั้งเดียว (OTP) ทางข้อความทางเบอร์โทรศัพท์ที่คุณลงทะเบียน'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(
            text:
            'สร้างบัญชีผู้ใช้งาน - คุณสามารถตั้งรหัสเป็นตัวเลข 6 หลักเพื่อเข้าใช้งาน ต้องเป็นตัวเลขที่คุณจำได้'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(
            text:
            'เบอร์โทรศัพท์ของคุณจะถูกตั้งเป็นชื่อผู้ใช้งาน โดยอัตโนมัติ'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(
            text:
            'หลังจากคุณสร้างบัญชีผู้ใช้งานสำเร็จ ระบบจะให้คุณกรอกข้อมูลเกี่ยวกับคุณ (ผู้ขอกู้)'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(
            text:
            'หลังจากกรอกแบบฟอร์มออนไลน์เรียบร้อย ให้ผู้ขอกู้อัพโหลด/ นำเข้า รูปเอกสารที่ต้องใช้ เช่น ใบอนุญาตทำงาน (บัตรชมพู) และ เอกสารรับเงินเดือน'),
      ]),
      ContentBlock.text(paddingLeft: 10, [
        Data(text: '- '),
        Data(
            text:
            'After you have finished filling in the form you will need to upload documents by taking a picture of some documents such as your pink card and pay slip'),
      ]),
      ContentBlock.text(paddingLeft: 10, [
        Data(text: '- '),
        Data(text: 'หน้าเซลฟี่'),
      ]),
      ContentBlock.text(paddingLeft: 10, [
        Data(text: '- '),
        Data(text: 'กรณีไม่ใช่คนไทย ใบอนุญาตทำงาน (บัตรชมพู หรือ  MOU)'),
      ]),
      ContentBlock.text(paddingLeft: 10, [
        Data(text: '- '),
        Data(text: 'หน้าบัญชีเงินฝากธนาคาร หรือ หนังสือรับรองเงินเดือน'),
      ]),
      ContentBlock.text(paddingLeft: 10, [
        Data(text: '- '),
        Data(text: 'บัตรประชาชน'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'ขอแนะนำให้ผู้ขอกู้ถ่ายรูปเอกสารเตรียมไว้ก่อนเริ่มกรอกฟอร์มออนไลน์ ในขั้นตอนที่ 1'),
      ]),
    ],
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'หลังจากสินพิธานได้รับข้อมูลผู้ขอกู้แล้ว หน่วยงานพิจารณาอนุมัติเงินกู้จะขอสัมภาษณ์ผู้ขอกู้ในภาษาที่ผู้ขอกู้สื่อสารได้'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'ขั้นตอนนี้เป็นการสัมภาษณ์ผ่านวิดีโอคอลสามารถทำทางโทรศัพท์มือถือได้'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: '(ใช้เวลาประมาณ 20 นาที)'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'ขั้นตอนนี้สามารถทำผ่านโทรศัพท์มือถือได้'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'ผู้ขอกู้ต้องเลือกวันและเวลาที่สะดวกเพื่อพูดคุยและให้สัมภาษณ์กับหน่วยงานพิจารณาอนุมัติเงินกู้ (ใช้เวลาไม่เกิน 30 นาที)'),
      ]),
    ],
    [
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'เมื่อวงเงินกู้ได้รับการอนุมัติผู้ขอกู้ต้องเดินทางไปทำสัญญาที่สำนักงานของสินพิธาน'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'ให้ผู้ขอกู้เลือกวันที่และช่วงเวลาที่สะดวกในการเข้าไปที่สำนักงาน (ขั้นตอนนี้จำเป็นสำหรับการกู้เงินครั้งแรกหรือการกู้เงินที่มากกว่า [10,000] บาท เท่านั้น)'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'เงินกู้ก้อนต่อไปผู้ขอกู้สามารถทำทุกขั้นตอนผ่านทางออนไลน์ในโทรศัพท์มือถือได้'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'เรามีเวลาให้เลือกในวันเสาร์ - อาทิตย์ หรือช่วงเย็นเพื่ออำนวยความสะดวกให้ผู้ขอกู้'),
      ]),
      ContentBlock.text([
        Data(text: '• '),
        Data(text: 'หลังจากลงชื่อในสัญญาเงินกู้ ผู้ขอกู้จะได้รับเงินกู้โอนเข้าบัญชีภายในวันเดียวกัน'),
      ]),
    ]
  ];
}
