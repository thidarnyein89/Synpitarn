import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synpitarn/data/language.dart';
import 'package:synpitarn/models/data.dart';

class LanguageService {

  static String translateKey(BuildContext context, String key) {
    switch (key) {
      case 'repayment':
        return AppLocalizations.of(context)!.repayment;
      case 'loanSchedule':
        return AppLocalizations.of(context)!.loanSchedule;
      case 'applyLoan':
        return AppLocalizations.of(context)!.applyLoan("");
      case 'documents':
        return AppLocalizations.of(context)!.documents;
      case 'callCenter':
        return AppLocalizations.of(context)!.callCenter;
      case 'apply':
        return AppLocalizations.of(context)!.apply;
      case 'interview':
        return AppLocalizations.of(context)!.interview;
      case 'preApproved':
        return AppLocalizations.of(context)!.preApproved;
      case 'disbursed':
        return AppLocalizations.of(context)!.disbursed;
      case 'workPermit':
        return AppLocalizations.of(context)!.workPermit;
      case 'customerInformation':
        return AppLocalizations.of(context)!.customerInformation;
      case 'requiredDocuments':
        return AppLocalizations.of(context)!.requiredDocuments;
      case 'additionalInformation':
        return AppLocalizations.of(context)!.additionalInformation;
      case 'loanType':
        return AppLocalizations.of(context)!.loanType;
      case 'interviewAppointment':
        return AppLocalizations.of(context)!.interviewAppointment;
      case 'changePhoneNumber':
        return AppLocalizations.of(context)!.changePhoneNumber;
      case 'basicInformation':
        return AppLocalizations.of(context)!.basicInformation;
      case 'additionalDocuments':
        return AppLocalizations.of(context)!.additionalDocuments;
      default:
        return key;
    }
  }

  static String translateLabel(Item item) {
    switch (Language.currentLanguage) {
      case LanguageType.en:
        return item.text?.en ?? '';
      case LanguageType.th:
        return item.text?.th ?? '';
      default:
        return item.text?.mm ?? '';
    }
  }

}