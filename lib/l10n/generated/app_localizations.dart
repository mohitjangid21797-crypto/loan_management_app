import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('as'),
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('ne'),
    Locale('or'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Loan Management App'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToAccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your loan dashboard'**
  String get signInToAccess;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit mobile number'**
  String get enterMobileNumber;

  /// No description provided for @emailId.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get emailId;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmailAddress;

  /// No description provided for @mpin.
  ///
  /// In en, this message translates to:
  /// **'M-PIN (6 Digit)'**
  String get mpin;

  /// No description provided for @enterMpin.
  ///
  /// In en, this message translates to:
  /// **'Enter your 6-digit M-PIN'**
  String get enterMpin;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get signingIn;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacy;

  /// No description provided for @invalidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get invalidName;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @invalidMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number'**
  String get invalidMobile;

  /// No description provided for @invalidMobileFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit Indian mobile number'**
  String get invalidMobileFormat;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get invalidEmail;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmailFormat;

  /// No description provided for @invalidMpin.
  ///
  /// In en, this message translates to:
  /// **'Please enter your M-PIN'**
  String get invalidMpin;

  /// No description provided for @invalidMpinFormat.
  ///
  /// In en, this message translates to:
  /// **'M-PIN must be exactly 6 digits'**
  String get invalidMpinFormat;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get nameLabel;

  /// No description provided for @mobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get emailLabel;

  /// No description provided for @mpinLabel.
  ///
  /// In en, this message translates to:
  /// **'M-PIN (6 Digit)'**
  String get mpinLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter customer\'s full name'**
  String get nameHint;

  /// No description provided for @mobileHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit mobile number'**
  String get mobileHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter customer\'s email address'**
  String get emailHint;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter city, state (e.g., Mumbai, Maharashtra)'**
  String get locationHint;

  /// No description provided for @invalidLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enter location'**
  String get invalidLocation;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @editCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get editCustomer;

  /// No description provided for @updateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Update Customer'**
  String get updateCustomer;

  /// No description provided for @deleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Delete Customer'**
  String get deleteCustomer;

  /// No description provided for @customerAdded.
  ///
  /// In en, this message translates to:
  /// **'Customer added successfully!'**
  String get customerAdded;

  /// No description provided for @customerUpdated.
  ///
  /// In en, this message translates to:
  /// **'Customer updated successfully!'**
  String get customerUpdated;

  /// No description provided for @confirmDeleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this customer? This will also delete all associated loans and EMIs.'**
  String get confirmDeleteCustomer;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search by name, mobile, or email'**
  String get searchCustomers;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No Customers Found'**
  String get noCustomersFound;

  /// No description provided for @noCustomersYet.
  ///
  /// In en, this message translates to:
  /// **'No Customers Yet'**
  String get noCustomersYet;

  /// No description provided for @addFirstCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add your first customer to get started'**
  String get addFirstCustomer;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @createLoan.
  ///
  /// In en, this message translates to:
  /// **'Create Loan'**
  String get createLoan;

  /// No description provided for @customerFound.
  ///
  /// In en, this message translates to:
  /// **'Customer Found'**
  String get customerFound;

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer Not Found'**
  String get customerNotFound;

  /// No description provided for @noCustomerRegistered.
  ///
  /// In en, this message translates to:
  /// **'No customer registered with this mobile number.'**
  String get noCustomerRegistered;

  /// No description provided for @addNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get addNewCustomer;

  /// No description provided for @findCustomer.
  ///
  /// In en, this message translates to:
  /// **'Find Customer'**
  String get findCustomer;

  /// No description provided for @searchByMobile.
  ///
  /// In en, this message translates to:
  /// **'Search by mobile number to create loan'**
  String get searchByMobile;

  /// No description provided for @enterMobileToSearch.
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit mobile number'**
  String get enterMobileToSearch;

  /// No description provided for @loanAmount.
  ///
  /// In en, this message translates to:
  /// **'Loan Amount (₹)'**
  String get loanAmount;

  /// No description provided for @enterLoanAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter principal amount'**
  String get enterLoanAmount;

  /// No description provided for @interestRate.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate (% p.a.)'**
  String get interestRate;

  /// No description provided for @enterInterestRate.
  ///
  /// In en, this message translates to:
  /// **'e.g., 10.5'**
  String get enterInterestRate;

  /// No description provided for @tenureMonths.
  ///
  /// In en, this message translates to:
  /// **'Tenure (Months)'**
  String get tenureMonths;

  /// No description provided for @enterTenure.
  ///
  /// In en, this message translates to:
  /// **'e.g., 24'**
  String get enterTenure;

  /// No description provided for @interestType.
  ///
  /// In en, this message translates to:
  /// **'Interest Type'**
  String get interestType;

  /// No description provided for @simpleInterest.
  ///
  /// In en, this message translates to:
  /// **'Simple Interest'**
  String get simpleInterest;

  /// No description provided for @simpleInterestDesc.
  ///
  /// In en, this message translates to:
  /// **'Interest calculated on principal only'**
  String get simpleInterestDesc;

  /// No description provided for @compoundInterest.
  ///
  /// In en, this message translates to:
  /// **'Compound Interest'**
  String get compoundInterest;

  /// No description provided for @compoundInterestDesc.
  ///
  /// In en, this message translates to:
  /// **'Interest calculated on principal + accumulated interest'**
  String get compoundInterestDesc;

  /// No description provided for @emiPreview.
  ///
  /// In en, this message translates to:
  /// **'EMI Preview'**
  String get emiPreview;

  /// No description provided for @monthlyEmi.
  ///
  /// In en, this message translates to:
  /// **'Monthly EMI'**
  String get monthlyEmi;

  /// No description provided for @totalInterest.
  ///
  /// In en, this message translates to:
  /// **'Total Interest'**
  String get totalInterest;

  /// No description provided for @totalPayable.
  ///
  /// In en, this message translates to:
  /// **'Total Payable'**
  String get totalPayable;

  /// No description provided for @createLoanButton.
  ///
  /// In en, this message translates to:
  /// **'Create Loan'**
  String get createLoanButton;

  /// No description provided for @loanCreated.
  ///
  /// In en, this message translates to:
  /// **'Loan created successfully! EMIs generated.'**
  String get loanCreated;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter loan amount'**
  String get invalidAmount;

  /// No description provided for @invalidAmountValue.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get invalidAmountValue;

  /// No description provided for @invalidRate.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get invalidRate;

  /// No description provided for @invalidRateValue.
  ///
  /// In en, this message translates to:
  /// **'Enter valid rate (1-50%)'**
  String get invalidRateValue;

  /// No description provided for @invalidTenure.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get invalidTenure;

  /// No description provided for @invalidTenureValue.
  ///
  /// In en, this message translates to:
  /// **'Enter valid tenure (1-360)'**
  String get invalidTenureValue;

  /// No description provided for @loans.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get loans;

  /// No description provided for @searchLoans.
  ///
  /// In en, this message translates to:
  /// **'Search loans...'**
  String get searchLoans;

  /// No description provided for @searchByLoanId.
  ///
  /// In en, this message translates to:
  /// **'Search by loan ID, customer name, or mobile'**
  String get searchByLoanId;

  /// No description provided for @noLoansFound.
  ///
  /// In en, this message translates to:
  /// **'No Loans Found'**
  String get noLoansFound;

  /// No description provided for @noLoansYet.
  ///
  /// In en, this message translates to:
  /// **'No Loans Yet'**
  String get noLoansYet;

  /// No description provided for @createFirstLoan.
  ///
  /// In en, this message translates to:
  /// **'Create your first loan to get started'**
  String get createFirstLoan;

  /// No description provided for @tryDifferentSearchOrFilter.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or filter'**
  String get tryDifferentSearchOrFilter;

  /// No description provided for @allLoans.
  ///
  /// In en, this message translates to:
  /// **'All Loans'**
  String get allLoans;

  /// No description provided for @activeOnly.
  ///
  /// In en, this message translates to:
  /// **'Active Only'**
  String get activeOnly;

  /// No description provided for @completedOnly.
  ///
  /// In en, this message translates to:
  /// **'Completed Only'**
  String get completedOnly;

  /// No description provided for @payEmi.
  ///
  /// In en, this message translates to:
  /// **'Pay EMI'**
  String get payEmi;

  /// No description provided for @viewPdf.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get viewPdf;

  /// No description provided for @loanDetails.
  ///
  /// In en, this message translates to:
  /// **'Loan Details'**
  String get loanDetails;

  /// No description provided for @principalAmount.
  ///
  /// In en, this message translates to:
  /// **'Principal Amount'**
  String get principalAmount;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @interestRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate'**
  String get interestRateLabel;

  /// No description provided for @tenureLabel.
  ///
  /// In en, this message translates to:
  /// **'Tenure'**
  String get tenureLabel;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @nextEmi.
  ///
  /// In en, this message translates to:
  /// **'Next EMI'**
  String get nextEmi;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @emiPayments.
  ///
  /// In en, this message translates to:
  /// **'EMI Payments'**
  String get emiPayments;

  /// No description provided for @loanSummary.
  ///
  /// In en, this message translates to:
  /// **'Loan Summary'**
  String get loanSummary;

  /// No description provided for @repaymentProgress.
  ///
  /// In en, this message translates to:
  /// **'Repayment Progress'**
  String get repaymentProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @payAllPending.
  ///
  /// In en, this message translates to:
  /// **'Pay All Pending EMIs'**
  String get payAllPending;

  /// No description provided for @confirmPayEmi.
  ///
  /// In en, this message translates to:
  /// **'Pay EMI #{installmentNumber}?'**
  String confirmPayEmi(Object installmentNumber);

  /// No description provided for @confirmPayAll.
  ///
  /// In en, this message translates to:
  /// **'Pay {count} pending EMIs at once?'**
  String confirmPayAll(Object count);

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @totalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmountLabel;

  /// No description provided for @allEmisPaid.
  ///
  /// In en, this message translates to:
  /// **'All EMIs paid successfully!'**
  String get allEmisPaid;

  /// No description provided for @paymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmation'**
  String get paymentConfirmation;

  /// No description provided for @paying.
  ///
  /// In en, this message translates to:
  /// **'Paying...'**
  String get paying;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @cheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get cheque;

  /// No description provided for @emiPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on {date}'**
  String emiPaidOn(Object date);

  /// No description provided for @emiOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get emiOverdue;

  /// No description provided for @emiPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get emiPending;

  /// No description provided for @emiPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get emiPaid;

  /// No description provided for @installment.
  ///
  /// In en, this message translates to:
  /// **'Inst. #'**
  String get installment;

  /// No description provided for @emiAmount.
  ///
  /// In en, this message translates to:
  /// **'EMI Amount'**
  String get emiAmount;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @paidDate.
  ///
  /// In en, this message translates to:
  /// **'Paid Date'**
  String get paidDate;

  /// No description provided for @emiSchedule.
  ///
  /// In en, this message translates to:
  /// **'EMI Schedule'**
  String get emiSchedule;

  /// No description provided for @loanOverview.
  ///
  /// In en, this message translates to:
  /// **'Loan Overview'**
  String get loanOverview;

  /// No description provided for @totalLoans.
  ///
  /// In en, this message translates to:
  /// **'Total Loans'**
  String get totalLoans;

  /// No description provided for @emiDue.
  ///
  /// In en, this message translates to:
  /// **'EMI Due'**
  String get emiDue;

  /// No description provided for @totalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total Customers'**
  String get totalCustomers;

  /// No description provided for @documentsGenerated.
  ///
  /// In en, this message translates to:
  /// **'Documents Generated'**
  String get documentsGenerated;

  /// No description provided for @activeLoans.
  ///
  /// In en, this message translates to:
  /// **'Active Loans'**
  String get activeLoans;

  /// No description provided for @recentLoans.
  ///
  /// In en, this message translates to:
  /// **'Recent Loans'**
  String get recentLoans;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language updated to {languageName}'**
  String languageChanged(Object languageName);

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get tamil;

  /// No description provided for @telugu.
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get telugu;

  /// No description provided for @bengali.
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get bengali;

  /// No description provided for @marathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get marathi;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'Gujarati'**
  String get gujarati;

  /// No description provided for @kannada.
  ///
  /// In en, this message translates to:
  /// **'Kannada'**
  String get kannada;

  /// No description provided for @malayalam.
  ///
  /// In en, this message translates to:
  /// **'Malayalam'**
  String get malayalam;

  /// No description provided for @punjabi.
  ///
  /// In en, this message translates to:
  /// **'Punjabi'**
  String get punjabi;

  /// No description provided for @odia.
  ///
  /// In en, this message translates to:
  /// **'Odia'**
  String get odia;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get urdu;

  /// No description provided for @assamese.
  ///
  /// In en, this message translates to:
  /// **'Assamese'**
  String get assamese;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @encryptedBackup.
  ///
  /// In en, this message translates to:
  /// **'Encrypted Backup'**
  String get encryptedBackup;

  /// No description provided for @encryptedRestore.
  ///
  /// In en, this message translates to:
  /// **'Encrypted Restore'**
  String get encryptedRestore;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Backup Now'**
  String get backupNow;

  /// No description provided for @connectAndBackup.
  ///
  /// In en, this message translates to:
  /// **'Connect & Backup'**
  String get connectAndBackup;

  /// No description provided for @backupCompleted.
  ///
  /// In en, this message translates to:
  /// **'Backup completed successfully! Encrypted and stored in Google Drive app data.'**
  String get backupCompleted;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get backupFailed;

  /// No description provided for @restoreCompleted.
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully! Please set a new M-PIN.'**
  String get restoreCompleted;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed - data may be corrupted'**
  String get restoreFailed;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password or no backup found'**
  String get invalidPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @backupPassword.
  ///
  /// In en, this message translates to:
  /// **'Backup Password'**
  String get backupPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterBackupPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a strong password'**
  String get enterBackupPassword;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get reEnterPassword;

  /// No description provided for @passwordWarning.
  ///
  /// In en, this message translates to:
  /// **'IMPORTANT: This password encrypts your backup. If you forget it, your data CANNOT be recovered. Google cannot help. Write it down and store it safely.'**
  String get passwordWarning;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signedOut.
  ///
  /// In en, this message translates to:
  /// **'Signed out from Google Drive'**
  String get signedOut;

  /// No description provided for @connectedToGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Connected to Google Drive'**
  String get connectedToGoogleDrive;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not Connected'**
  String get notConnected;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Google account to create an encrypted backup. Your data is encrypted on your device with AES-256-GCM before upload. Google never sees your unencrypted data.'**
  String get signInWithGoogle;

  /// No description provided for @recentBackups.
  ///
  /// In en, this message translates to:
  /// **'Recent Backups (max 5 kept)'**
  String get recentBackups;

  /// No description provided for @maxBackups.
  ///
  /// In en, this message translates to:
  /// **'Max 5 Backups'**
  String get maxBackups;

  /// No description provided for @maxBackupsDesc.
  ///
  /// In en, this message translates to:
  /// **'Only the 5 most recent backups are kept. Older ones are auto-deleted.'**
  String get maxBackupsDesc;

  /// No description provided for @securityNotes.
  ///
  /// In en, this message translates to:
  /// **'Security Notes'**
  String get securityNotes;

  /// No description provided for @encryptionInfo.
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted with AES-256-GCM on your device before upload. The key is derived from your password using PBKDF2 (200,000 rounds).'**
  String get encryptionInfo;

  /// No description provided for @passwordNotStored.
  ///
  /// In en, this message translates to:
  /// **'The app never stores your backup password. If you forget it, your backup CANNOT be decrypted. Not by you, not by Google, not by us.'**
  String get passwordNotStored;

  /// No description provided for @hiddenFolder.
  ///
  /// In en, this message translates to:
  /// **'Backups go to Google Drive\'s hidden \"app data\" folder. You cannot see them in Drive, and no other app can access them.'**
  String get hiddenFolder;

  /// No description provided for @lmbkFormat.
  ///
  /// In en, this message translates to:
  /// **'Backups use custom LMBK format: magic bytes + version + salt + IV + encrypted data + auth tag.'**
  String get lmbkFormat;

  /// No description provided for @mpinNotBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Your M-PIN is deliberately excluded from backups. After restore, you must set a new M-PIN.'**
  String get mpinNotBackedUp;

  /// No description provided for @onlineOnly.
  ///
  /// In en, this message translates to:
  /// **'Backup/restore require internet. The rest of the app works fully offline.'**
  String get onlineOnly;

  /// No description provided for @appInformation.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @dataStorage.
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get dataStorage;

  /// No description provided for @backupFormat.
  ///
  /// In en, this message translates to:
  /// **'Backup Format'**
  String get backupFormat;

  /// No description provided for @backupLocation.
  ///
  /// In en, this message translates to:
  /// **'Backup Location'**
  String get backupLocation;

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last Backup'**
  String get lastBackup;

  /// No description provided for @localStorage.
  ///
  /// In en, this message translates to:
  /// **'Local (SharedPreferences)'**
  String get localStorage;

  /// No description provided for @backupFormatDesc.
  ///
  /// In en, this message translates to:
  /// **'LMBK v1 (AES-256-GCM)'**
  String get backupFormatDesc;

  /// No description provided for @backupLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Google Drive App Data Folder'**
  String get backupLocationDesc;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @pdfGenerated.
  ///
  /// In en, this message translates to:
  /// **'PDF Generated'**
  String get pdfGenerated;

  /// No description provided for @viewPdfButton.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get viewPdfButton;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @editRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Edit/Regenerate'**
  String get editRegenerate;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @pdfOptions.
  ///
  /// In en, this message translates to:
  /// **'PDF Options'**
  String get pdfOptions;

  /// No description provided for @choosePdfLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose PDF language'**
  String get choosePdfLanguage;

  /// No description provided for @selectedPdfLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use selected app language ({languageName})'**
  String selectedPdfLanguage(Object languageName);

  /// No description provided for @pdfSystemHeading.
  ///
  /// In en, this message translates to:
  /// **'LOAN MANAGEMENT SYSTEM'**
  String get pdfSystemHeading;

  /// No description provided for @pdfAgreementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Loan Agreement & Payment Summary'**
  String get pdfAgreementSubtitle;

  /// No description provided for @monthsCount.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get monthsCount;

  /// No description provided for @smartFinancialSolutions.
  ///
  /// In en, this message translates to:
  /// **'Smart Financial Solutions'**
  String get smartFinancialSolutions;

  /// No description provided for @backupYourData.
  ///
  /// In en, this message translates to:
  /// **'Backup Your Data'**
  String get backupYourData;

  /// No description provided for @backupYourDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Secure your loan data by backing it up to Google Drive. You can restore it anytime, even after reinstalling the app.'**
  String get backupYourDataDescription;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdated;

  /// No description provided for @lenderDetails.
  ///
  /// In en, this message translates to:
  /// **'Lender Details'**
  String get lenderDetails;

  /// No description provided for @missingPdfData.
  ///
  /// In en, this message translates to:
  /// **'Missing data to generate PDF'**
  String get missingPdfData;

  /// No description provided for @deleteDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Document'**
  String get deleteDocumentTitle;

  /// No description provided for @confirmDeletePdf.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this PDF document?'**
  String get confirmDeletePdf;

  /// No description provided for @documentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get documentDeleted;

  /// No description provided for @groupedByCustomer.
  ///
  /// In en, this message translates to:
  /// **'Grouped by Customer'**
  String get groupedByCustomer;

  /// No description provided for @noCustomerForMobile.
  ///
  /// In en, this message translates to:
  /// **'No customer registered with this mobile number.\nPlease add the customer first.'**
  String get noCustomerForMobile;

  /// No description provided for @customerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Customer deleted successfully!'**
  String get customerDeleted;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// No description provided for @amountColon.
  ///
  /// In en, this message translates to:
  /// **'Amount:'**
  String get amountColon;

  /// No description provided for @dueDateColon.
  ///
  /// In en, this message translates to:
  /// **'Due Date:'**
  String get dueDateColon;

  /// No description provided for @totalAmountColon.
  ///
  /// In en, this message translates to:
  /// **'Total Amount:'**
  String get totalAmountColon;

  /// No description provided for @payAll.
  ///
  /// In en, this message translates to:
  /// **'Pay All'**
  String get payAll;

  /// No description provided for @backupPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the password you used when creating this backup.'**
  String get backupPasswordPrompt;

  /// No description provided for @restoreEncryptedBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore from Encrypted Backup'**
  String get restoreEncryptedBackup;

  /// No description provided for @restoreGoogleAccountInstruction.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the same Google account. You will need the backup password you set during backup. After restore, you must set a new M-PIN (M-PIN is not stored in backups for security).'**
  String get restoreGoogleAccountInstruction;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @choosePreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get choosePreferredLanguage;

  /// No description provided for @customerDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'Customer deleted'**
  String get customerDeletedToast;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @loanDocuments.
  ///
  /// In en, this message translates to:
  /// **'Loan Documents'**
  String get loanDocuments;

  /// No description provided for @allDocuments.
  ///
  /// In en, this message translates to:
  /// **'All Documents'**
  String get allDocuments;

  /// No description provided for @noDocumentsFound.
  ///
  /// In en, this message translates to:
  /// **'No Documents Found'**
  String get noDocumentsFound;

  /// No description provided for @completeEmisForPdf.
  ///
  /// In en, this message translates to:
  /// **'Complete all EMI payments to generate loan agreement PDF'**
  String get completeEmisForPdf;

  /// No description provided for @docsAppearAfterLoan.
  ///
  /// In en, this message translates to:
  /// **'Documents will appear here after loan completion'**
  String get docsAppearAfterLoan;

  /// No description provided for @backToLoans.
  ///
  /// In en, this message translates to:
  /// **'Back to Loans'**
  String get backToLoans;

  /// No description provided for @pdfGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF Generated'**
  String get pdfGeneratedSuccess;

  /// No description provided for @customerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetails;

  /// No description provided for @loanAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Loan Amount'**
  String get loanAmountLabel;

  /// No description provided for @emisPaid.
  ///
  /// In en, this message translates to:
  /// **'EMIs Paid'**
  String get emisPaid;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @viewPdfAction.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get viewPdfAction;

  /// No description provided for @shareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAction;

  /// No description provided for @regenerateAction.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerateAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @viewPdfActionShort.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get viewPdfActionShort;

  /// No description provided for @shareActionShort.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareActionShort;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get editAction;

  /// No description provided for @deleteActionShort.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteActionShort;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @totalEmis.
  ///
  /// In en, this message translates to:
  /// **'Total EMIs'**
  String get totalEmis;

  /// No description provided for @paidEmis.
  ///
  /// In en, this message translates to:
  /// **'Paid EMIs'**
  String get paidEmis;

  /// No description provided for @pendingEmis.
  ///
  /// In en, this message translates to:
  /// **'Pending EMIs'**
  String get pendingEmis;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @totalPending.
  ///
  /// In en, this message translates to:
  /// **'Total Pending'**
  String get totalPending;

  /// No description provided for @totalLoan.
  ///
  /// In en, this message translates to:
  /// **'Total Loan'**
  String get totalLoan;

  /// No description provided for @emiScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'EMI Schedule'**
  String get emiScheduleTitle;

  /// No description provided for @installmentHeader.
  ///
  /// In en, this message translates to:
  /// **'Inst. #'**
  String get installmentHeader;

  /// No description provided for @dueDateHeader.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDateHeader;

  /// No description provided for @emiAmountHeader.
  ///
  /// In en, this message translates to:
  /// **'EMI Amount'**
  String get emiAmountHeader;

  /// No description provided for @statusHeader.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusHeader;

  /// No description provided for @paidDateHeader.
  ///
  /// In en, this message translates to:
  /// **'Paid Date'**
  String get paidDateHeader;

  /// No description provided for @loanAgreementTitle.
  ///
  /// In en, this message translates to:
  /// **'LOAN AGREEMENT'**
  String get loanAgreementTitle;

  /// No description provided for @partiesTitle.
  ///
  /// In en, this message translates to:
  /// **'PARTIES TO THE AGREEMENT'**
  String get partiesTitle;

  /// No description provided for @lenderLabel.
  ///
  /// In en, this message translates to:
  /// **'LENDER'**
  String get lenderLabel;

  /// No description provided for @borrowerLabel.
  ///
  /// In en, this message translates to:
  /// **'BORROWER'**
  String get borrowerLabel;

  /// No description provided for @mobileLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobileLabelShort;

  /// No description provided for @emailLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabelShort;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @licenseLabel.
  ///
  /// In en, this message translates to:
  /// **'License No'**
  String get licenseLabel;

  /// No description provided for @locationLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabelShort;

  /// No description provided for @loanDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'LOAN DETAILS'**
  String get loanDetailsTitle;

  /// No description provided for @principalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Principal Amount'**
  String get principalAmountLabel;

  /// No description provided for @interestRateLabelFull.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate'**
  String get interestRateLabelFull;

  /// No description provided for @tenureLabelFull.
  ///
  /// In en, this message translates to:
  /// **'Tenure'**
  String get tenureLabelFull;

  /// No description provided for @interestTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Interest Type'**
  String get interestTypeLabel;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDateLabel;

  /// No description provided for @monthlyEmiLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly EMI'**
  String get monthlyEmiLabel;

  /// No description provided for @totalInterestLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Interest'**
  String get totalInterestLabel;

  /// No description provided for @totalPayableLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Payable'**
  String get totalPayableLabel;

  /// No description provided for @loanStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Loan Status'**
  String get loanStatusLabel;

  /// No description provided for @loanIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Loan ID'**
  String get loanIdLabel;

  /// No description provided for @simpleInterestLabel.
  ///
  /// In en, this message translates to:
  /// **'Simple Interest'**
  String get simpleInterestLabel;

  /// No description provided for @compoundInterestLabel.
  ///
  /// In en, this message translates to:
  /// **'Compound Interest'**
  String get compoundInterestLabel;

  /// No description provided for @paymentSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT SUMMARY'**
  String get paymentSummaryTitle;

  /// No description provided for @totalEmisLabel.
  ///
  /// In en, this message translates to:
  /// **'Total EMIs'**
  String get totalEmisLabel;

  /// No description provided for @paidEmisLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid EMIs'**
  String get paidEmisLabel;

  /// No description provided for @pendingEmisLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending EMIs'**
  String get pendingEmisLabel;

  /// No description provided for @totalPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaidLabel;

  /// No description provided for @totalPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Pending'**
  String get totalPendingLabel;

  /// No description provided for @totalLoanLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Loan'**
  String get totalLoanLabel;

  /// No description provided for @lenderSignature.
  ///
  /// In en, this message translates to:
  /// **'Lender Signature'**
  String get lenderSignature;

  /// No description provided for @borrowerSignature.
  ///
  /// In en, this message translates to:
  /// **'Borrower Signature'**
  String get borrowerSignature;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @footerText.
  ///
  /// In en, this message translates to:
  /// **'This document is computer-generated and does not require physical signature for validation.'**
  String get footerText;

  /// No description provided for @confidentialLabel.
  ///
  /// In en, this message translates to:
  /// **'Loan Management System | Confidential Document'**
  String get confidentialLabel;

  /// No description provided for @generatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get generatedLabel;

  /// No description provided for @docIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Doc ID'**
  String get docIdLabel;

  /// No description provided for @lenderName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get lenderName;

  /// No description provided for @lenderMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get lenderMobile;

  /// No description provided for @lenderEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get lenderEmail;

  /// No description provided for @lenderAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get lenderAddress;

  /// No description provided for @lenderLicense.
  ///
  /// In en, this message translates to:
  /// **'License No'**
  String get lenderLicense;

  /// No description provided for @borrowerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get borrowerName;

  /// No description provided for @borrowerMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get borrowerMobile;

  /// No description provided for @borrowerEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get borrowerEmail;

  /// No description provided for @borrowerLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get borrowerLocation;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearSearch;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @activeFilter.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeFilter;

  /// No description provided for @completedFilter.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedFilter;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes'**
  String get unsavedChanges;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChanges;

  /// No description provided for @confirmDiscard.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to discard your changes?'**
  String get confirmDiscard;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Rs.'**
  String get currencySymbol;

  /// No description provided for @currencyCode.
  ///
  /// In en, this message translates to:
  /// **'INR'**
  String get currencyCode;

  /// No description provided for @rupees.
  ///
  /// In en, this message translates to:
  /// **'Rs.'**
  String get rupees;

  /// No description provided for @lakh.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get lakh;

  /// No description provided for @crore.
  ///
  /// In en, this message translates to:
  /// **'Cr'**
  String get crore;

  /// No description provided for @thousand.
  ///
  /// In en, this message translates to:
  /// **'K'**
  String get thousand;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @chooseOption.
  ///
  /// In en, this message translates to:
  /// **'Choose an option'**
  String get chooseOption;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @minLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum length is {count} characters'**
  String minLength(Object count);

  /// No description provided for @maxLength.
  ///
  /// In en, this message translates to:
  /// **'Maximum length is {count} characters'**
  String maxLength(Object count);

  /// No description provided for @mustBeNumber.
  ///
  /// In en, this message translates to:
  /// **'Must be a number'**
  String get mustBeNumber;

  /// No description provided for @mustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Must be a positive number'**
  String get mustBePositive;

  /// No description provided for @mustBeInteger.
  ///
  /// In en, this message translates to:
  /// **'Must be a whole number'**
  String get mustBeInteger;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get emailAlreadyExists;

  /// No description provided for @mobileAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Mobile number already exists'**
  String get mobileAlreadyExists;

  /// No description provided for @customerExists.
  ///
  /// In en, this message translates to:
  /// **'Customer already exists'**
  String get customerExists;

  /// No description provided for @loanExists.
  ///
  /// In en, this message translates to:
  /// **'Loan already exists'**
  String get loanExists;

  /// No description provided for @documentExists.
  ///
  /// In en, this message translates to:
  /// **'Document already exists'**
  String get documentExists;

  /// No description provided for @backupExists.
  ///
  /// In en, this message translates to:
  /// **'Backup already exists'**
  String get backupExists;

  /// No description provided for @restoreWarning.
  ///
  /// In en, this message translates to:
  /// **'This will replace all current data. Are you sure?'**
  String get restoreWarning;

  /// No description provided for @dataRestored.
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully!'**
  String get dataRestored;

  /// No description provided for @dataBackupUp.
  ///
  /// In en, this message translates to:
  /// **'Data backed up successfully!'**
  String get dataBackupUp;

  /// No description provided for @mpinSetup.
  ///
  /// In en, this message translates to:
  /// **'Set M-PIN'**
  String get mpinSetup;

  /// No description provided for @confirmMpin.
  ///
  /// In en, this message translates to:
  /// **'Confirm M-PIN'**
  String get confirmMpin;

  /// No description provided for @mpinMismatch.
  ///
  /// In en, this message translates to:
  /// **'M-PINs do not match'**
  String get mpinMismatch;

  /// No description provided for @mpinSet.
  ///
  /// In en, this message translates to:
  /// **'M-PIN set successfully!'**
  String get mpinSet;

  /// No description provided for @mpinChanged.
  ///
  /// In en, this message translates to:
  /// **'M-PIN changed successfully!'**
  String get mpinChanged;

  /// No description provided for @currentMpin.
  ///
  /// In en, this message translates to:
  /// **'Current M-PIN'**
  String get currentMpin;

  /// No description provided for @newMpin.
  ///
  /// In en, this message translates to:
  /// **'New M-PIN'**
  String get newMpin;

  /// No description provided for @changeMpin.
  ///
  /// In en, this message translates to:
  /// **'Change M-PIN'**
  String get changeMpin;

  /// No description provided for @forgotMpin.
  ///
  /// In en, this message translates to:
  /// **'Forgot M-PIN?'**
  String get forgotMpin;

  /// No description provided for @resetMpin.
  ///
  /// In en, this message translates to:
  /// **'Reset M-PIN'**
  String get resetMpin;

  /// No description provided for @verifyIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify Identity'**
  String get verifyIdentity;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @codeSent.
  ///
  /// In en, this message translates to:
  /// **'Code sent to your registered mobile/email'**
  String get codeSent;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidCode;

  /// No description provided for @codeExpired.
  ///
  /// In en, this message translates to:
  /// **'Verification code expired'**
  String get codeExpired;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @permissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Permissions required'**
  String get permissionsRequired;

  /// No description provided for @grantPermissions.
  ///
  /// In en, this message translates to:
  /// **'Please grant the required permissions'**
  String get grantPermissions;

  /// No description provided for @storagePermission.
  ///
  /// In en, this message translates to:
  /// **'Storage permission required'**
  String get storagePermission;

  /// No description provided for @cameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get cameraPermission;

  /// No description provided for @contactsPermission.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission required'**
  String get contactsPermission;

  /// No description provided for @locationPermission.
  ///
  /// In en, this message translates to:
  /// **'Location permission required'**
  String get locationPermission;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get notificationPermission;

  /// No description provided for @internetRequired.
  ///
  /// In en, this message translates to:
  /// **'Internet connection required'**
  String get internetRequired;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @dataSync.
  ///
  /// In en, this message translates to:
  /// **'Data Sync'**
  String get dataSync;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced'**
  String get lastSynced;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get syncFailed;

  /// No description provided for @syncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sync successful'**
  String get syncSuccess;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get autoSync;

  /// No description provided for @wifiOnlySync.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Only Sync'**
  String get wifiOnlySync;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @smallFont.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get smallFont;

  /// No description provided for @mediumFont.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumFont;

  /// No description provided for @largeFont.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get largeFont;

  /// No description provided for @extraLargeFont.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get extraLargeFont;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// No description provided for @reminderNotifications.
  ///
  /// In en, this message translates to:
  /// **'Reminder Notifications'**
  String get reminderNotifications;

  /// No description provided for @paymentReminders.
  ///
  /// In en, this message translates to:
  /// **'Payment Reminders'**
  String get paymentReminders;

  /// No description provided for @dueSoonReminders.
  ///
  /// In en, this message translates to:
  /// **'Due Soon Reminders'**
  String get dueSoonReminders;

  /// No description provided for @overdueReminders.
  ///
  /// In en, this message translates to:
  /// **'Overdue Reminders'**
  String get overdueReminders;

  /// No description provided for @marketingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Marketing Notifications'**
  String get marketingNotifications;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report a Bug'**
  String get reportBug;

  /// No description provided for @featureRequest.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get featureRequest;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @userGuide.
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get userGuide;

  /// No description provided for @tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// No description provided for @loanManagement.
  ///
  /// In en, this message translates to:
  /// **'Loan Management'**
  String get loanManagement;

  /// No description provided for @customerManagement.
  ///
  /// In en, this message translates to:
  /// **'Customer Management'**
  String get customerManagement;

  /// No description provided for @paymentTracking.
  ///
  /// In en, this message translates to:
  /// **'Payment Tracking'**
  String get paymentTracking;

  /// No description provided for @documentGeneration.
  ///
  /// In en, this message translates to:
  /// **'Document Generation'**
  String get documentGeneration;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestore;

  /// No description provided for @multiLanguage.
  ///
  /// In en, this message translates to:
  /// **'Multi-Language Support'**
  String get multiLanguage;

  /// No description provided for @secureData.
  ///
  /// In en, this message translates to:
  /// **'Secure Data'**
  String get secureData;

  /// No description provided for @offlineAccess.
  ///
  /// In en, this message translates to:
  /// **'Offline Access'**
  String get offlineAccess;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @viewAllActivity.
  ///
  /// In en, this message translates to:
  /// **'View All Activity'**
  String get viewAllActivity;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @attachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach File'**
  String get attachFile;

  /// No description provided for @removeFile.
  ///
  /// In en, this message translates to:
  /// **'Remove File'**
  String get removeFile;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File too large'**
  String get fileTooLarge;

  /// No description provided for @invalidFileType.
  ///
  /// In en, this message translates to:
  /// **'Invalid file type'**
  String get invalidFileType;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get downloadComplete;

  /// No description provided for @uploadComplete.
  ///
  /// In en, this message translates to:
  /// **'Upload complete'**
  String get uploadComplete;

  /// No description provided for @operationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Operation successful!'**
  String get operationSuccess;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get operationFailed;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get timeoutError;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access'**
  String get unauthorized;

  /// No description provided for @forbidden.
  ///
  /// In en, this message translates to:
  /// **'Access forbidden'**
  String get forbidden;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Validation error'**
  String get validationError;

  /// No description provided for @duplicateEntry.
  ///
  /// In en, this message translates to:
  /// **'Duplicate entry'**
  String get duplicateEntry;

  /// No description provided for @constraintViolation.
  ///
  /// In en, this message translates to:
  /// **'Constraint violation'**
  String get constraintViolation;

  /// No description provided for @databaseError.
  ///
  /// In en, this message translates to:
  /// **'Database error'**
  String get databaseError;

  /// No description provided for @connectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get connectionLost;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting...'**
  String get reconnecting;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last Sync'**
  String get lastSync;

  /// No description provided for @autoSyncEnabled.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync Enabled'**
  String get autoSyncEnabled;

  /// No description provided for @wifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Only'**
  String get wifiOnly;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @storageUsage.
  ///
  /// In en, this message translates to:
  /// **'Storage Usage'**
  String get storageUsage;

  /// No description provided for @cacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache Size'**
  String get cacheSize;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearData.
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// No description provided for @resetApp.
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get resetApp;

  /// No description provided for @confirmReset.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset the app? All data will be lost.'**
  String get confirmReset;

  /// No description provided for @appReset.
  ///
  /// In en, this message translates to:
  /// **'App has been reset'**
  String get appReset;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @viewLogs.
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get viewLogs;

  /// No description provided for @exportLogs.
  ///
  /// In en, this message translates to:
  /// **'Export Logs'**
  String get exportLogs;

  /// No description provided for @clearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogs;

  /// No description provided for @debugMode.
  ///
  /// In en, this message translates to:
  /// **'Debug Mode'**
  String get debugMode;

  /// No description provided for @developerOptions.
  ///
  /// In en, this message translates to:
  /// **'Developer Options'**
  String get developerOptions;

  /// No description provided for @versionCode.
  ///
  /// In en, this message translates to:
  /// **'Version Code'**
  String get versionCode;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageName;

  /// No description provided for @appSignature.
  ///
  /// In en, this message translates to:
  /// **'App Signature'**
  String get appSignature;

  /// No description provided for @installSource.
  ///
  /// In en, this message translates to:
  /// **'Install Source'**
  String get installSource;

  /// No description provided for @deviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device Info'**
  String get deviceInfo;

  /// No description provided for @osVersion.
  ///
  /// In en, this message translates to:
  /// **'OS Version'**
  String get osVersion;

  /// No description provided for @deviceModel.
  ///
  /// In en, this message translates to:
  /// **'Device Model'**
  String get deviceModel;

  /// No description provided for @manufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get manufacturer;

  /// No description provided for @screenResolution.
  ///
  /// In en, this message translates to:
  /// **'Screen Resolution'**
  String get screenResolution;

  /// No description provided for @density.
  ///
  /// In en, this message translates to:
  /// **'Density'**
  String get density;

  /// No description provided for @totalStorage.
  ///
  /// In en, this message translates to:
  /// **'Total Storage'**
  String get totalStorage;

  /// No description provided for @availableStorage.
  ///
  /// In en, this message translates to:
  /// **'Available Storage'**
  String get availableStorage;

  /// No description provided for @memoryUsage.
  ///
  /// In en, this message translates to:
  /// **'Memory Usage'**
  String get memoryUsage;

  /// No description provided for @cpuUsage.
  ///
  /// In en, this message translates to:
  /// **'CPU Usage'**
  String get cpuUsage;

  /// No description provided for @batteryLevel.
  ///
  /// In en, this message translates to:
  /// **'Battery Level'**
  String get batteryLevel;

  /// No description provided for @networkType.
  ///
  /// In en, this message translates to:
  /// **'Network Type'**
  String get networkType;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @macAddress.
  ///
  /// In en, this message translates to:
  /// **'MAC Address'**
  String get macAddress;

  /// No description provided for @imei.
  ///
  /// In en, this message translates to:
  /// **'IMEI'**
  String get imei;

  /// No description provided for @simOperator.
  ///
  /// In en, this message translates to:
  /// **'SIM Operator'**
  String get simOperator;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'Country Code'**
  String get countryCode;

  /// No description provided for @timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezone;

  /// No description provided for @locale.
  ///
  /// In en, this message translates to:
  /// **'Locale'**
  String get locale;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get timeFormat;

  /// No description provided for @weekStart.
  ///
  /// In en, this message translates to:
  /// **'Week Start'**
  String get weekStart;

  /// No description provided for @firstDayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'First Day of Week'**
  String get firstDayOfWeek;

  /// No description provided for @numberFormat.
  ///
  /// In en, this message translates to:
  /// **'Number Format'**
  String get numberFormat;

  /// No description provided for @decimalSeparator.
  ///
  /// In en, this message translates to:
  /// **'Decimal Separator'**
  String get decimalSeparator;

  /// No description provided for @thousandSeparator.
  ///
  /// In en, this message translates to:
  /// **'Thousand Separator'**
  String get thousandSeparator;

  /// No description provided for @listSeparator.
  ///
  /// In en, this message translates to:
  /// **'List Separator'**
  String get listSeparator;

  /// No description provided for @measurementSystem.
  ///
  /// In en, this message translates to:
  /// **'Measurement System'**
  String get measurementSystem;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature Unit'**
  String get temperatureUnit;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get celsius;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get fahrenheit;

  /// No description provided for @windSpeedUnit.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed Unit'**
  String get windSpeedUnit;

  /// No description provided for @pressureUnit.
  ///
  /// In en, this message translates to:
  /// **'Pressure Unit'**
  String get pressureUnit;

  /// No description provided for @visibilityUnit.
  ///
  /// In en, this message translates to:
  /// **'Visibility Unit'**
  String get visibilityUnit;

  /// No description provided for @precipitationUnit.
  ///
  /// In en, this message translates to:
  /// **'Precipitation Unit'**
  String get precipitationUnit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'as',
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'ne',
    'or',
    'pa',
    'ta',
    'te',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ne':
      return AppLocalizationsNe();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
