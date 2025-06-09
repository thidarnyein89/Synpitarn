import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my'),
    Locale('th')
  ];

  /// No description provided for @additionalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Additional Documents'**
  String get additionalDocuments;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// No description provided for @agreeTermCondition.
  ///
  /// In en, this message translates to:
  /// **'Agree Term & Condition'**
  String get agreeTermCondition;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @applyLoan.
  ///
  /// In en, this message translates to:
  /// **'Apply Loan'**
  String applyLoan(Object loanNumber);

  /// No description provided for @applyLoanButton.
  ///
  /// In en, this message translates to:
  /// **'Apply Loan'**
  String get applyLoanButton;

  /// No description provided for @appointmentBranch.
  ///
  /// In en, this message translates to:
  /// **'Appointment Branch'**
  String get appointmentBranch;

  /// No description provided for @appointmentDate.
  ///
  /// In en, this message translates to:
  /// **'Appointment Date'**
  String get appointmentDate;

  /// No description provided for @appointmentSuccess1.
  ///
  /// In en, this message translates to:
  /// **'Thank you for submitting your loan application form.'**
  String get appointmentSuccess1;

  /// No description provided for @appointmentSuccess2.
  ///
  /// In en, this message translates to:
  /// **'Syn Pitarn staff are reviewing your loan application. We may have to contact you to re-upload any document that is not clear. The next step is for you to have a quick video call with our staff at the time and date you previously selected.'**
  String get appointmentSuccess2;

  /// No description provided for @appointmentTime.
  ///
  /// In en, this message translates to:
  /// **'Available time'**
  String get appointmentTime;

  /// No description provided for @appointmentInformation.
  ///
  /// In en, this message translates to:
  /// **'Appointment Information'**
  String get appointmentInformation;

  /// No description provided for @approvedLoan.
  ///
  /// In en, this message translates to:
  /// **'Approved Loan'**
  String get approvedLoan;

  /// No description provided for @bahts.
  ///
  /// In en, this message translates to:
  /// **'Baht'**
  String get bahts;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @branchAppointment.
  ///
  /// In en, this message translates to:
  /// **'Branch Appointment'**
  String get branchAppointment;

  /// No description provided for @callCenter.
  ///
  /// In en, this message translates to:
  /// **'Call Center'**
  String get callCenter;

  /// No description provided for @callMobile.
  ///
  /// In en, this message translates to:
  /// **'Call us on mobile'**
  String get callMobile;

  /// No description provided for @callMobileButton.
  ///
  /// In en, this message translates to:
  /// **'Call Centre'**
  String get callMobileButton;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @canNotCallPhone.
  ///
  /// In en, this message translates to:
  /// **'Cannot launch phone dialer'**
  String get canNotCallPhone;

  /// No description provided for @canNotOpenMessenger.
  ///
  /// In en, this message translates to:
  /// **'Could not launch Messenger'**
  String get canNotOpenMessenger;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneNumber;

  /// No description provided for @citizen.
  ///
  /// In en, this message translates to:
  /// **'Citizen'**
  String get citizen;

  /// No description provided for @clickHere.
  ///
  /// In en, this message translates to:
  /// **'click here'**
  String get clickHere;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @confirmDeleteImage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete this image?'**
  String get confirmDeleteImage;

  /// No description provided for @confirmOk.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get confirmOk;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @contractNo.
  ///
  /// In en, this message translates to:
  /// **'Contract No'**
  String get contractNo;

  /// No description provided for @currentApplyLoan.
  ///
  /// In en, this message translates to:
  /// **'Current Apply Loan'**
  String get currentApplyLoan;

  /// No description provided for @currentPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Current Phone Number'**
  String get currentPhoneNumber;

  /// No description provided for @customerInformation.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInformation;

  /// No description provided for @disbursed.
  ///
  /// In en, this message translates to:
  /// **'Disbursed'**
  String get disbursed;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dob;

  /// No description provided for @doHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Do you have an account, '**
  String get doHaveAnAccount;

  /// No description provided for @doNotHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account, '**
  String get doNotHaveAnAccount;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @documentRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'We are sorry to inform you that your loan information needs updated information. Please update your information.'**
  String get documentRequestMessage;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Download completed'**
  String get downloadComplete;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @branchAppointmentDate.
  ///
  /// In en, this message translates to:
  /// **'Branch Appointment Date'**
  String get branchAppointmentDate;

  /// No description provided for @branchAppointmentTime.
  ///
  /// In en, this message translates to:
  /// **'Branch Appointment Time'**
  String get branchAppointmentTime;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @editInformation.
  ///
  /// In en, this message translates to:
  /// **'Edit Information'**
  String get editInformation;

  /// No description provided for @editInformationButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Information'**
  String get editInformationButton;

  /// No description provided for @existingUser.
  ///
  /// In en, this message translates to:
  /// **'Existing User?'**
  String get existingUser;

  /// No description provided for @firstPaymentDate.
  ///
  /// In en, this message translates to:
  /// **'First Payment Date'**
  String get firstPaymentDate;

  /// No description provided for @forgotPinCode.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN code'**
  String get forgotPinCode;

  /// No description provided for @getToKnowUs.
  ///
  /// In en, this message translates to:
  /// **'Get to know us'**
  String get getToKnowUs;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @goToHomePage.
  ///
  /// In en, this message translates to:
  /// **'Go To Home Page'**
  String get goToHomePage;

  /// No description provided for @goToDirection.
  ///
  /// In en, this message translates to:
  /// **'Go To Direction'**
  String get goToDirection;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @howToApplyLoan.
  ///
  /// In en, this message translates to:
  /// **'How To Apply For A Loan'**
  String get howToApplyLoan;

  /// No description provided for @incomeType.
  ///
  /// In en, this message translates to:
  /// **'How often are you paid'**
  String get incomeType;

  /// No description provided for @interview.
  ///
  /// In en, this message translates to:
  /// **'Interview'**
  String get interview;

  /// No description provided for @interviewAppointment.
  ///
  /// In en, this message translates to:
  /// **'Interview Appointment'**
  String get interviewAppointment;

  /// No description provided for @interviewAppointmentButton.
  ///
  /// In en, this message translates to:
  /// **'Resubmit Interview Appointment'**
  String get interviewAppointmentButton;

  /// No description provided for @interviewAppointmentDate.
  ///
  /// In en, this message translates to:
  /// **'Appointment date'**
  String get interviewAppointmentDate;

  /// No description provided for @interviewAppointmentTime.
  ///
  /// In en, this message translates to:
  /// **'Available time'**
  String get interviewAppointmentTime;

  /// No description provided for @interviewAppointmentMessage.
  ///
  /// In en, this message translates to:
  /// **'You need to take interview appointment again'**
  String get interviewAppointmentMessage;

  /// No description provided for @lastPaymentDate.
  ///
  /// In en, this message translates to:
  /// **'Last Payment Date'**
  String get lastPaymentDate;

  /// No description provided for @lengthTimeCurrentEmployer.
  ///
  /// In en, this message translates to:
  /// **'Length of time at current employer'**
  String get lengthTimeCurrentEmployer;

  /// No description provided for @loan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get loan;

  /// No description provided for @loanApplication.
  ///
  /// In en, this message translates to:
  /// **'Loan Application'**
  String get loanApplication;

  /// No description provided for @loanAppliedDate.
  ///
  /// In en, this message translates to:
  /// **'Loan Applied Date'**
  String get loanAppliedDate;

  /// No description provided for @loanInformation.
  ///
  /// In en, this message translates to:
  /// **'Loan Information'**
  String get loanInformation;

  /// No description provided for @loanSchedule.
  ///
  /// In en, this message translates to:
  /// **'Loan Schedule'**
  String get loanSchedule;

  /// No description provided for @loanSize.
  ///
  /// In en, this message translates to:
  /// **'Loan Size'**
  String get loanSize;

  /// No description provided for @loanStatus.
  ///
  /// In en, this message translates to:
  /// **'Loan Status'**
  String get loanStatus;

  /// No description provided for @loanTerm.
  ///
  /// In en, this message translates to:
  /// **'Loan Term'**
  String get loanTerm;

  /// No description provided for @loanType.
  ///
  /// In en, this message translates to:
  /// **'Loan Type'**
  String get loanType;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Existing User?'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @makeAppointment.
  ///
  /// In en, this message translates to:
  /// **'Make Appointment'**
  String get makeAppointment;

  /// No description provided for @mainPurposeLoan.
  ///
  /// In en, this message translates to:
  /// **'Main purpose of loan'**
  String get mainPurposeLoan;

  /// No description provided for @manualFill.
  ///
  /// In en, this message translates to:
  /// **'Manual Fill'**
  String get manualFill;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nearestATM.
  ///
  /// In en, this message translates to:
  /// **'Nearest ATM'**
  String get nearestATM;

  /// No description provided for @nearestBranch.
  ///
  /// In en, this message translates to:
  /// **'Nearest Branch'**
  String get nearestBranch;

  /// No description provided for @noAdditionalDocuments.
  ///
  /// In en, this message translates to:
  /// **'There is no additional documents.'**
  String get noAdditionalDocuments;

  /// No description provided for @noApplyLoan.
  ///
  /// In en, this message translates to:
  /// **'There is no apply loan'**
  String get noApplyLoan;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @noRepaymentSchedule.
  ///
  /// In en, this message translates to:
  /// **'There is no current repayment schedule'**
  String get noRepaymentSchedule;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notification;

  /// No description provided for @notificationNothing.
  ///
  /// In en, this message translates to:
  /// **'There is no notification.'**
  String get notificationNothing;

  /// No description provided for @nrcNumber.
  ///
  /// In en, this message translates to:
  /// **'NRC Number'**
  String get nrcNumber;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @openAccount.
  ///
  /// In en, this message translates to:
  /// **'Apply Loan with open account'**
  String get openAccount;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @otherReasons.
  ///
  /// In en, this message translates to:
  /// **''**
  String get otherReasons;

  /// No description provided for @otpCodeContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6 digits number that we have sent to you here then click \"Verify OTP Code\" below.'**
  String get otpCodeContent;

  /// No description provided for @otpExpireMessage.
  ///
  /// In en, this message translates to:
  /// **'OTP Code will expire in {minutes}:{seconds}'**
  String otpExpireMessage(Object minutes, Object seconds);

  /// No description provided for @otpNotReceived.
  ///
  /// In en, this message translates to:
  /// **'OTP not received? '**
  String get otpNotReceived;

  /// No description provided for @passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get passport;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @paymentAtATM.
  ///
  /// In en, this message translates to:
  /// **'Payment at ATM'**
  String get paymentAtATM;

  /// No description provided for @paymentAtOnline.
  ///
  /// In en, this message translates to:
  /// **'Payment via mobile banking'**
  String get paymentAtOnline;

  /// No description provided for @pendingLoan.
  ///
  /// In en, this message translates to:
  /// **'Pending Loan Application'**
  String get pendingLoan;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please Wait...'**
  String get pleaseWait;

  /// No description provided for @postponedLoan.
  ///
  /// In en, this message translates to:
  /// **'Your loan has been postponed'**
  String get postponedLoan;

  /// No description provided for @preApproved.
  ///
  /// In en, this message translates to:
  /// **'Pre-approved'**
  String get preApproved;

  /// No description provided for @preApprovedLoan.
  ///
  /// In en, this message translates to:
  /// **'Pre Approved Loan'**
  String get preApprovedLoan;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @provinceResidence.
  ///
  /// In en, this message translates to:
  /// **'Province of residence'**
  String get provinceResidence;

  /// No description provided for @provinceWork.
  ///
  /// In en, this message translates to:
  /// **'Province of work'**
  String get provinceWork;

  /// No description provided for @reachOnline.
  ///
  /// In en, this message translates to:
  /// **'Reach us online'**
  String get reachOnline;

  /// No description provided for @rejectedMessage1.
  ///
  /// In en, this message translates to:
  /// **'We are sorry to say that your loan application is rejected'**
  String get rejectedMessage1;

  /// No description provided for @rejectedMessage2.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your application. We have reviewed but your qualification does not meet our criteria'**
  String get rejectedMessage2;

  /// No description provided for @rejectedMessage3.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you can’t request another loan currently. But don’t worry, you can request again on '**
  String get rejectedMessage3;

  /// No description provided for @rejectedMessage4.
  ///
  /// In en, this message translates to:
  /// **''**
  String get rejectedMessage4;

  /// No description provided for @rememberPhonePincode1.
  ///
  /// In en, this message translates to:
  /// **'Please remember your phone number which is your username '**
  String get rememberPhonePincode1;

  /// No description provided for @rememberPhonePincode2.
  ///
  /// In en, this message translates to:
  /// **' and your PIN code '**
  String get rememberPhonePincode2;

  /// No description provided for @rememberPhonePincode3.
  ///
  /// In en, this message translates to:
  /// **' to login to your account at any time.'**
  String get rememberPhonePincode3;

  /// No description provided for @repayment.
  ///
  /// In en, this message translates to:
  /// **'Repayment'**
  String get repayment;

  /// No description provided for @repayAtBranch.
  ///
  /// In en, this message translates to:
  /// **'Repay at a branch'**
  String get repayAtBranch;

  /// No description provided for @repaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Repayment amount'**
  String get repaymentAmount;

  /// No description provided for @repaymentDate.
  ///
  /// In en, this message translates to:
  /// **'Repayment date'**
  String get repaymentDate;

  /// No description provided for @repaymentLateDay.
  ///
  /// In en, this message translates to:
  /// **'Your repayment is {totalLateDay} days late.'**
  String repaymentLateDay(Object totalLateDay);

  /// No description provided for @repaymentLateDescription1.
  ///
  /// In en, this message translates to:
  /// **'Your repayment is now {para1} days late. Please make a payment of {para2} immediately or click '**
  String repaymentLateDescription1(Object para1, Object para2);

  /// No description provided for @repaymentLateDescription2.
  ///
  /// In en, this message translates to:
  /// **'here (messenger link)'**
  String get repaymentLateDescription2;

  /// No description provided for @repaymentLateDescription3.
  ///
  /// In en, this message translates to:
  /// **' to contact your loan officer'**
  String get repaymentLateDescription3;

  /// No description provided for @repaymentLateMessage.
  ///
  /// In en, this message translates to:
  /// **'Please make a payment to maintain good credit.'**
  String get repaymentLateMessage;

  /// No description provided for @repaymentSchedule.
  ///
  /// In en, this message translates to:
  /// **'Repayment Schedule'**
  String get repaymentSchedule;

  /// No description provided for @repaymentTerm.
  ///
  /// In en, this message translates to:
  /// **'Repayment Term'**
  String get repaymentTerm;

  /// No description provided for @requestInterviewDate.
  ///
  /// In en, this message translates to:
  /// **'Request Interview Date'**
  String get requestInterviewDate;

  /// No description provided for @requestInterviewTime.
  ///
  /// In en, this message translates to:
  /// **'Request Interview Time'**
  String get requestInterviewTime;

  /// No description provided for @requiredDocuments.
  ///
  /// In en, this message translates to:
  /// **'Required Documents'**
  String get requiredDocuments;

  /// No description provided for @resendOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP Code'**
  String get resendOtpCode;

  /// No description provided for @resetPinCode.
  ///
  /// In en, this message translates to:
  /// **'Reset PIN code'**
  String get resetPinCode;

  /// No description provided for @reUploadMsg1.
  ///
  /// In en, this message translates to:
  /// **'We found out that your '**
  String get reUploadMsg1;

  /// No description provided for @reUploadMsg2.
  ///
  /// In en, this message translates to:
  /// **' is blurred and we would like you to upload that document again for your loan application.'**
  String get reUploadMsg2;

  /// No description provided for @reUploadRequest.
  ///
  /// In en, this message translates to:
  /// **'Reupload Request'**
  String get reUploadRequest;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Total income (Salary + Overtime + Other Income) (Baht)'**
  String get salary;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @setPincode.
  ///
  /// In en, this message translates to:
  /// **'Set Your Pin Code'**
  String get setPincode;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @socialMediaChannel.
  ///
  /// In en, this message translates to:
  /// **'Social media channel'**
  String get socialMediaChannel;

  /// No description provided for @socialMediaURL.
  ///
  /// In en, this message translates to:
  /// **'Social Media Url'**
  String get socialMediaURL;

  /// No description provided for @termCondition.
  ///
  /// In en, this message translates to:
  /// **'Term and Condtions'**
  String get termCondition;

  /// No description provided for @termConditionAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to SynPitarn Co. Ltd\'s terms and conditions'**
  String get termConditionAgree;

  /// No description provided for @termConditionMessage.
  ///
  /// In en, this message translates to:
  /// **'When you click continue you will be asked to agree to our terms. After that you will be sent an OTP to the phone number that you gave us.'**
  String get termConditionMessage;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **''**
  String get time;

  /// No description provided for @township.
  ///
  /// In en, this message translates to:
  /// **'Township'**
  String get township;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @verifyOTPCode.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP code'**
  String get verifyOTPCode;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewRepaymentSchedule.
  ///
  /// In en, this message translates to:
  /// **'View Repayment Schedule'**
  String get viewRepaymentSchedule;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'SynPitarn will use this phone number as the primary authentication method. Please fill in the phone number that you always use and is with you.'**
  String get welcomeDescription;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SynPitarn'**
  String get welcomeMessage;

  /// No description provided for @workPermit.
  ///
  /// In en, this message translates to:
  /// **'Work Permit'**
  String get workPermit;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'my', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'my': return AppLocalizationsMy();
    case 'th': return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
