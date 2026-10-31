// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'قرض مینجمنٹ ایپ';

  @override
  String get welcomeBack => 'واپسی پر خوش آمدید';

  @override
  String get signInToAccess => 'اپنے قرض ڈیش بورڈ تک رسائی کے لیے سائن ان کریں';

  @override
  String get fullName => 'پورا نام';

  @override
  String get enterFullName => 'اپنا پورا نام درج کریں';

  @override
  String get mobileNumber => 'موبائل نمبر';

  @override
  String get enterMobileNumber => '10 ہندسوں کا موبائل نمبر درج کریں';

  @override
  String get emailId => 'ای میل آئی ڈی';

  @override
  String get enterEmailAddress => 'اپنا ای میل پتہ درج کریں';

  @override
  String get mpin => 'ایم-پن (6 ہندسے)';

  @override
  String get enterMpin => 'اپنا 6 ہندسوں کا ایم-پن درج کریں';

  @override
  String get signIn => 'سائن ان کریں';

  @override
  String get signingIn => 'سائن ان ہو رہا ہے...';

  @override
  String get termsAndPrivacy =>
      'سائن ان کر کے، آپ ہماری سروس کی شرائط اور رازداری کی پالیسی سے متفق ہیں';

  @override
  String get invalidName => 'براہ کرم اپنا نام درج کریں';

  @override
  String get nameTooShort => 'نام کم از کم 2 حروف کا ہونا چاہیے';

  @override
  String get invalidMobile => 'براہ کرم اپنا موبائل نمبر درج کریں';

  @override
  String get invalidMobileFormat =>
      'درست 10 ہندسوں کا بھارتی موبائل نمبر درج کریں';

  @override
  String get invalidEmail => 'براہ کرم اپنا ای میل درج کریں';

  @override
  String get invalidEmailFormat => 'درست ای میل پتہ درج کریں';

  @override
  String get invalidMpin => 'براہ کرم اپنا ایم-پن درج کریں';

  @override
  String get invalidMpinFormat => 'ایم-پن بالکل 6 ہندسوں کا ہونا چاہیے';

  @override
  String get nameLabel => 'پورا نام';

  @override
  String get mobileLabel => 'موبائل نمبر';

  @override
  String get emailLabel => 'ای میل آئی ڈی';

  @override
  String get mpinLabel => 'ایم-پن (6 ہندسے)';

  @override
  String get nameHint => 'گاہک کا پورا نام درج کریں';

  @override
  String get mobileHint => '10 ہندسوں کا موبائل نمبر درج کریں';

  @override
  String get emailHint => 'گاہک کا ای میل پتہ درج کریں';

  @override
  String get locationLabel => 'مقام';

  @override
  String get locationHint => 'شہر، ریاست درج کریں (مثلاً، ممبئی، مہاراشٹرہ)';

  @override
  String get invalidLocation => 'براہ کرم مقام درج کریں';

  @override
  String get addCustomer => 'گاہک شامل کریں';

  @override
  String get editCustomer => 'گاہک میں ترمیم کریں';

  @override
  String get updateCustomer => 'گاہک کو اپ ڈیٹ کریں';

  @override
  String get deleteCustomer => 'گاہک حذف کریں';

  @override
  String get customerAdded => 'گاہک کامیابی سے شامل ہو گیا!';

  @override
  String get customerUpdated => 'گاہک کامیابی سے اپ ڈیٹ ہو گیا!';

  @override
  String get confirmDeleteCustomer =>
      'کیا آپ واقعی اس گاہک کو حذف کرنا چاہتے ہیں؟ یہ تمام متعلقہ قرضے اور EMIs بھی حذف کر دے گا۔';

  @override
  String get customers => 'گاہک';

  @override
  String get searchCustomers => 'نام، موبائل یا ای میل سے تلاش کریں';

  @override
  String get noCustomersFound => 'کوئی گاہک نہیں ملا';

  @override
  String get noCustomersYet => 'ابھی تک کوئی گاہک نہیں';

  @override
  String get addFirstCustomer => 'شروع کرنے کے لیے اپنا پہلا گاہک شامل کریں';

  @override
  String get tryDifferentSearch => 'کوئی مختلف تلاش کا لفظ آزمائیں';

  @override
  String get viewDetails => 'تفصیلات دیکھیں';

  @override
  String get createLoan => 'قرض بنائیں';

  @override
  String get customerFound => 'گاہک ملا';

  @override
  String get customerNotFound => 'گاہک نہیں ملا';

  @override
  String get noCustomerRegistered =>
      'اس موبائل نمبر سے کوئی گاہک رجسٹر نہیں ہے۔';

  @override
  String get addNewCustomer => 'نیا گاہک شامل کریں';

  @override
  String get findCustomer => 'گاہک تلاش کریں';

  @override
  String get searchByMobile => 'قرض بنانے کے لیے موبائل نمبر سے تلاش کریں';

  @override
  String get enterMobileToSearch => '10 ہندسوں کا موبائل نمبر درج کریں';

  @override
  String get loanAmount => 'قرض کی رقم (₹)';

  @override
  String get enterLoanAmount => 'اصل رقم درج کریں';

  @override
  String get interestRate => 'سود کی شرح (% سالانہ)';

  @override
  String get enterInterestRate => 'مثلاً، 10.5';

  @override
  String get tenureMonths => 'مدت (مہینے)';

  @override
  String get enterTenure => 'مثلاً، 24';

  @override
  String get interestType => 'سود کی قسم';

  @override
  String get simpleInterest => 'سادہ سود';

  @override
  String get simpleInterestDesc => 'سود صرف اصل رقم پر شمار کیا جاتا ہے';

  @override
  String get compoundInterest => 'مرکب سود';

  @override
  String get compoundInterestDesc =>
      'سود اصل رقم + جمع شدہ سود پر شمار کیا جاتا ہے';

  @override
  String get emiPreview => 'EMI پیش منظر';

  @override
  String get monthlyEmi => 'ماہانہ EMI';

  @override
  String get totalInterest => 'کل سود';

  @override
  String get totalPayable => 'کل قابل ادائیگی';

  @override
  String get createLoanButton => 'قرض بنائیں';

  @override
  String get loanCreated => 'قرض کامیابی سے بنایا گیا! EMIs تیار ہو گئے۔';

  @override
  String get invalidAmount => 'براہ کرم قرض کی رقم درج کریں';

  @override
  String get invalidAmountValue => 'درست رقم درج کریں';

  @override
  String get invalidRate => 'درکار ہے';

  @override
  String get invalidRateValue => 'درست شرح درج کریں (1-50%)';

  @override
  String get invalidTenure => 'درکار ہے';

  @override
  String get invalidTenureValue => 'درست مدت درج کریں (1-360)';

  @override
  String get loans => 'قرضے';

  @override
  String get searchLoans => 'قرضے تلاش کریں...';

  @override
  String get searchByLoanId =>
      'قرض کی آئی ڈی، گاہک کا نام یا موبائل سے تلاش کریں';

  @override
  String get noLoansFound => 'کوئی قرض نہیں ملا';

  @override
  String get noLoansYet => 'ابھی تک کوئی قرض نہیں';

  @override
  String get createFirstLoan => 'شروع کرنے کے لیے اپنا پہلا قرض بنائیں';

  @override
  String get tryDifferentSearchOrFilter =>
      'کوئی مختلف تلاش کا لفظ یا فلٹر آزمائیں';

  @override
  String get allLoans => 'تمام قرضے';

  @override
  String get activeOnly => 'صرف فعال';

  @override
  String get completedOnly => 'صرف مکمل';

  @override
  String get payEmi => 'EMI ادا کریں';

  @override
  String get viewPdf => 'PDF دیکھیں';

  @override
  String get loanDetails => 'قرض کی تفصیلات';

  @override
  String get principalAmount => 'اصل رقم';

  @override
  String get totalAmount => 'کل رقم';

  @override
  String get interestRateLabel => 'سود کی شرح';

  @override
  String get tenureLabel => 'مدت';

  @override
  String get progress => 'پیش رفت';

  @override
  String get paid => 'ادا شدہ';

  @override
  String get pending => 'زیر التواء';

  @override
  String get overdue => 'میعاد گزری';

  @override
  String get nextEmi => 'اگلی EMI';

  @override
  String get due => 'قابل ادائیگی';

  @override
  String get emiPayments => 'EMI ادائیگیاں';

  @override
  String get loanSummary => 'قرض کا خلاصہ';

  @override
  String get repaymentProgress => 'ادائیگی کی پیش رفت';

  @override
  String get completed => 'مکمل';

  @override
  String get payNow => 'ابھی ادا کریں';

  @override
  String get payAllPending => 'تمام زیر التواء EMIs ادا کریں';

  @override
  String confirmPayEmi(Object installmentNumber) {
    return 'EMI #$installmentNumber ادا کریں؟';
  }

  @override
  String confirmPayAll(Object count) {
    return '$count زیر التواء EMIs ایک ساتھ ادا کریں؟';
  }

  @override
  String get amount => 'رقم';

  @override
  String get dueDate => 'ادائیگی کی تاریخ';

  @override
  String get totalAmountLabel => 'کل رقم';

  @override
  String get allEmisPaid => 'تمام EMIs کامیابی سے ادا ہو گئیں!';

  @override
  String get paymentConfirmation => 'ادائیگی کی تصدیق';

  @override
  String get paying => 'ادا ہو رہا ہے...';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String get paymentMethod => 'ادائیگی کا طریقہ';

  @override
  String get cash => 'نقد';

  @override
  String get cheque => 'چیک';

  @override
  String emiPaidOn(Object date) {
    return '$date کو ادا کیا گیا';
  }

  @override
  String get emiOverdue => 'میعاد گزری';

  @override
  String get emiPending => 'زیر التواء';

  @override
  String get emiPaid => 'EMI کامیابی سے ادا ہو گئی!';

  @override
  String get installment => 'قسط #';

  @override
  String get emiAmount => 'EMI رقم';

  @override
  String get status => 'حالت';

  @override
  String get paidDate => 'ادائیگی کی تاریخ';

  @override
  String get emiSchedule => 'EMI شیڈول';

  @override
  String get loanOverview => 'قرض کا جائزہ';

  @override
  String get totalLoans => 'کل قرضے';

  @override
  String get emiDue => 'قابل ادائیگی EMI';

  @override
  String get totalCustomers => 'کل گاہک';

  @override
  String get documentsGenerated => 'تیار کردہ دستاویزات';

  @override
  String get activeLoans => 'فعال قرضے';

  @override
  String get recentLoans => 'حالیہ قرضے';

  @override
  String get viewAll => 'سب دیکھیں';

  @override
  String get goodMorning => 'صبح بخیر';

  @override
  String get goodAfternoon => 'دوپہر بخیر';

  @override
  String get goodEvening => 'شام بخیر';

  @override
  String get notifications => 'اطلاعات';

  @override
  String get profile => 'پروفائل';

  @override
  String get settings => 'ترتیبات';

  @override
  String get language => 'زبان';

  @override
  String get selectLanguage => 'زبان منتخب کریں';

  @override
  String languageChanged(Object languageName) {
    return 'زبان $languageName میں تبدیل ہو گئی';
  }

  @override
  String get english => 'انگریزی';

  @override
  String get hindi => 'ہندی';

  @override
  String get tamil => 'تمل';

  @override
  String get telugu => 'تیلگو';

  @override
  String get bengali => 'بنگالی';

  @override
  String get marathi => 'مراٹھی';

  @override
  String get gujarati => 'گجراتی';

  @override
  String get kannada => 'کنڑ';

  @override
  String get malayalam => 'ملیالم';

  @override
  String get punjabi => 'پنجابی';

  @override
  String get odia => 'اڑیہ';

  @override
  String get urdu => 'اردو';

  @override
  String get assamese => 'آسامی';

  @override
  String get backup => 'بیک اپ';

  @override
  String get restore => 'بحال کریں';

  @override
  String get encryptedBackup => 'خفیہ کردہ بیک اپ';

  @override
  String get encryptedRestore => 'خفیہ کردہ بحالی';

  @override
  String get backupNow => 'ابھی بیک اپ لیں';

  @override
  String get connectAndBackup => 'جڑیں اور بیک اپ لیں';

  @override
  String get backupCompleted =>
      'بیک اپ کامیابی سے مکمل! خفیہ کر کے Google Drive ایپ ڈیٹا میں محفوظ کیا گیا۔';

  @override
  String get backupFailed => 'بیک اپ ناکام';

  @override
  String get restoreCompleted =>
      'ڈیٹا کامیابی سے بحال ہو گیا! براہ کرم نیا ایم-پن سیٹ کریں۔';

  @override
  String get restoreFailed => 'بحالی ناکام - ڈیٹا خراب ہو سکتا ہے';

  @override
  String get invalidPassword => 'غلط پاس ورڈ یا کوئی بیک اپ نہیں ملا';

  @override
  String get passwordMismatch => 'پاس ورڈ میچ نہیں کرتے';

  @override
  String get passwordTooShort => 'پاس ورڈ کم از کم 8 حروف کا ہونا چاہیے';

  @override
  String get backupPassword => 'بیک اپ پاس ورڈ';

  @override
  String get confirmPassword => 'پاس ورڈ کی تصدیق کریں';

  @override
  String get enterBackupPassword => 'مضبوط پاس ورڈ درج کریں';

  @override
  String get reEnterPassword => 'پاس ورڈ دوبارہ درج کریں';

  @override
  String get passwordWarning =>
      'اہم: یہ پاس ورڈ آپ کے بیک اپ کو خفیہ کرتا ہے۔ اگر آپ اسے بھول جائیں تو آپ کا ڈیٹا بحال نہیں ہو سکتا۔ Google مدد نہیں کر سکتا۔ اسے لکھ کر محفوظ رکھیں۔';

  @override
  String get signOut => 'سائن آؤٹ';

  @override
  String get signedOut => 'Google Drive سے سائن آؤٹ ہو گیا';

  @override
  String get connectedToGoogleDrive => 'Google Drive سے منسلک';

  @override
  String get notConnected => 'منسلک نہیں';

  @override
  String get signInWithGoogle =>
      'خفیہ کردہ بیک اپ بنانے کے لیے اپنے Google اکاؤنٹ سے سائن ان کریں۔ اپ لوڈ سے پہلے آپ کا ڈیٹا AES-256-GCM سے خفیہ کیا جاتا ہے۔ Google کبھی آپ کا غیر خفیہ ڈیٹا نہیں دیکھتا۔';

  @override
  String get recentBackups => 'حالیہ بیک اپس (زیادہ سے زیادہ 5 رکھے جاتے ہیں)';

  @override
  String get maxBackups => 'زیادہ سے زیادہ 5 بیک اپس';

  @override
  String get maxBackupsDesc =>
      'صرف 5 حالیہ ترین بیک اپس رکھے جاتے ہیں۔ پرانے خودکار طور پر حذف ہو جاتے ہیں۔';

  @override
  String get securityNotes => 'سیکیورٹی نوٹس';

  @override
  String get encryptionInfo =>
      'اپ لوڈ سے پہلے آپ کا ڈیٹا آپ کے ڈیوائس پر AES-256-GCM سے خفیہ کیا جاتا ہے۔ کلید آپ کے پاس ورڈ سے PBKDF2 (200,000 راؤنڈز) استعمال کرتے ہوئے حاصل کی جاتی ہے۔';

  @override
  String get passwordNotStored =>
      'ایپ کبھی آپ کا بیک اپ پاس ورڈ محفوظ نہیں کرتی۔ اگر آپ اسے بھول جائیں تو آپ کا بیک اپ ڈی کرپٹ نہیں ہو سکتا۔ نہ آپ، نہ Google، نہ ہم۔';

  @override
  String get hiddenFolder =>
      'بیک اپس Google Drive کے چھپے ہوئے \"ایپ ڈیٹا\" فولڈر میں جاتے ہیں۔ آپ انہیں Drive میں نہیں دیکھ سکتے، اور کوئی دوسری ایپ ان تک رسائی نہیں کر سکتی۔';

  @override
  String get lmbkFormat =>
      'بیک اپس حسب ضرورت LMBK فارمیٹ استعمال کرتے ہیں: جادوئی بائٹس + ورژن + سالٹ + IV + خفیہ کردہ ڈیٹا + آتھ ٹیگ۔';

  @override
  String get mpinNotBackedUp =>
      'آپ کا ایم-پن جان بوجھ کر بیک اپس سے خارج کر دیا گیا ہے۔ بحالی کے بعد، آپ کو نیا ایم-پن سیٹ کرنا ہوگا۔';

  @override
  String get onlineOnly =>
      'بیک اپ/بحالی کے لیے انٹرنیٹ درکار ہے۔ باقی ایپ مکمل طور پر آف لائن کام کرتی ہے۔';

  @override
  String get appInformation => 'ایپ کی معلومات';

  @override
  String get appVersion => 'ایپ ورژن';

  @override
  String get dataStorage => 'ڈیٹا اسٹوریج';

  @override
  String get backupFormat => 'بیک اپ فارمیٹ';

  @override
  String get backupLocation => 'بیک اپ کی جگہ';

  @override
  String get lastBackup => 'آخری بیک اپ';

  @override
  String get localStorage => 'مقامی (SQLite database)';

  @override
  String get backupFormatDesc => 'LMBK v2 (AES-256-GCM)';

  @override
  String get backupLocationDesc => 'Google Drive ایپ ڈیٹا فولڈر';

  @override
  String get never => 'کبھی نہیں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get edit => 'ترمیم کریں';

  @override
  String get view => 'دیکھیں';

  @override
  String get regenerate => 'دوبارہ بنائیں';

  @override
  String get share => 'شیئر کریں';

  @override
  String get pdfGenerated => 'PDF تیار ہو گئی';

  @override
  String get viewPdfButton => 'PDF دیکھیں';

  @override
  String get shareButton => 'شیئر کریں';

  @override
  String get editRegenerate => 'ترمیم/دوبارہ بنائیں';

  @override
  String get deleteButton => 'حذف کریں';

  @override
  String get pdfOptions => 'PDF کے اختیارات';

  @override
  String get choosePdfLanguage => 'PDF کی زبان منتخب کریں';

  @override
  String selectedPdfLanguage(Object languageName) {
    return 'منتخب کردہ ایپ کی زبان استعمال کریں ($languageName)';
  }

  @override
  String get pdfSystemHeading => 'قرض کے انتظام کا نظام';

  @override
  String get pdfAgreementSubtitle => 'قرض کا معاہدہ اور ادائیگی کا خلاصہ';

  @override
  String get monthsCount => 'مہینے';

  @override
  String get smartFinancialSolutions => 'اسمارٹ مالیاتی حل';

  @override
  String get backupYourData => 'اپنے ڈیٹا کا بیک اپ لیں';

  @override
  String get backupYourDataDescription =>
      'اپنے قرض کے ڈیٹا کو Google Drive پر بیک اپ کرکے محفوظ رکھیں۔ ایپ دوبارہ انسٹال کرنے کے بعد بھی آپ اسے کسی بھی وقت بحال کر سکتے ہیں۔';

  @override
  String get profileUpdated => 'پروفائل کامیابی سے اپ ڈیٹ ہو گیا!';

  @override
  String get lenderDetails => 'قرض دہندہ کی تفصیلات';

  @override
  String get missingPdfData => 'PDF بنانے کے لیے درکار ڈیٹا موجود نہیں';

  @override
  String get deleteDocumentTitle => 'دستاویز حذف کریں';

  @override
  String get confirmDeletePdf =>
      'کیا آپ واقعی یہ PDF دستاویز حذف کرنا چاہتے ہیں؟';

  @override
  String get documentDeleted => 'دستاویز حذف کر دی گئی';

  @override
  String get groupedByCustomer => 'صارف کے لحاظ سے گروپ کیا گیا';

  @override
  String get noCustomerForMobile =>
      'اس موبائل نمبر پر کوئی صارف رجسٹرڈ نہیں ہے۔\nبراہِ کرم پہلے صارف شامل کریں۔';

  @override
  String get customerDeleted => 'گاہک کامیابی سے حذف ہو گیا!';

  @override
  String get confirmPayment => 'ادائیگی کی تصدیق کریں';

  @override
  String get amountColon => 'رقم:';

  @override
  String get dueDateColon => 'آخری تاریخ:';

  @override
  String get totalAmountColon => 'کل رقم:';

  @override
  String get payAll => 'سب ادا کریں';

  @override
  String get backupPasswordPrompt =>
      'یہ بیک اپ بناتے وقت استعمال کیا گیا پاس ورڈ درج کریں۔';

  @override
  String get restoreEncryptedBackup => 'انکرپٹ شدہ بیک اپ سے بحال کریں';

  @override
  String get restoreGoogleAccountInstruction =>
      'اسی Google اکاؤنٹ سے سائن اِن کریں۔ بیک اپ بناتے وقت مقرر کیا گیا پاس ورڈ درکار ہوگا۔ بحالی کے بعد آپ کو نیا M-PIN سیٹ کرنا ہوگا (سیکیورٹی کی خاطر بیک اپ میں M-PIN محفوظ نہیں کیا جاتا)۔';

  @override
  String get appLanguage => 'ایپ کی زبان';

  @override
  String get choosePreferredLanguage => 'اپنی پسندیدہ زبان منتخب کریں';

  @override
  String get customerDeletedToast => 'صارف حذف کر دیا گیا';

  @override
  String get documents => 'دستاویزات';

  @override
  String get loanDocuments => 'قرض کی دستاویزات';

  @override
  String get allDocuments => 'تمام دستاویزات';

  @override
  String get noDocumentsFound => 'کوئی دستاویز نہیں ملی';

  @override
  String get completeEmisForPdf =>
      'قرض کے معاہدے کی PDF بنانے کے لیے تمام EMI ادائیگیاں مکمل کریں';

  @override
  String get docsAppearAfterLoan =>
      'قرض مکمل ہونے کے بعد دستاویزات یہاں ظاہر ہوں گی';

  @override
  String get backToLoans => 'قرضوں پر واپس جائیں';

  @override
  String get pdfGeneratedSuccess => 'PDF تیار ہو گئی';

  @override
  String get customerDetails => 'گاہک کی تفصیلات';

  @override
  String get loanAmountLabel => 'قرض کی رقم';

  @override
  String get emisPaid => 'ادا شدہ EMIs';

  @override
  String get totalLabel => 'کل';

  @override
  String get viewPdfAction => 'PDF دیکھیں';

  @override
  String get shareAction => 'شیئر کریں';

  @override
  String get regenerateAction => 'دوبارہ بنائیں';

  @override
  String get deleteAction => 'حذف کریں';

  @override
  String get viewPdfActionShort => 'PDF دیکھیں';

  @override
  String get shareActionShort => 'شیئر کریں';

  @override
  String get editAction => 'دوبارہ بنائیں';

  @override
  String get deleteActionShort => 'حذف کریں';

  @override
  String get paymentSummary => 'ادائیگی کا خلاصہ';

  @override
  String get totalEmis => 'کل EMIs';

  @override
  String get paidEmis => 'ادا شدہ EMIs';

  @override
  String get pendingEmis => 'زیر التواء EMIs';

  @override
  String get totalPaid => 'کل ادا شدہ';

  @override
  String get totalPending => 'کل زیر التواء';

  @override
  String get totalLoan => 'کل قرض';

  @override
  String get emiScheduleTitle => 'EMI شیڈول';

  @override
  String get installmentHeader => 'قسط #';

  @override
  String get dueDateHeader => 'ادائیگی کی تاریخ';

  @override
  String get emiAmountHeader => 'EMI رقم';

  @override
  String get statusHeader => 'حالت';

  @override
  String get paidDateHeader => 'ادائیگی کی تاریخ';

  @override
  String get loanAgreementTitle => 'قرض کا معاہدہ';

  @override
  String get partiesTitle => 'معاہدے کے فریقین';

  @override
  String get lenderLabel => 'قرض دہندہ';

  @override
  String get borrowerLabel => 'قرض لینے والا';

  @override
  String get mobileLabelShort => 'موبائل';

  @override
  String get emailLabelShort => 'ای میل';

  @override
  String get addressLabel => 'پتہ';

  @override
  String get licenseLabel => 'لائسنس نمبر';

  @override
  String get locationLabelShort => 'مقام';

  @override
  String get loanDetailsTitle => 'قرض کی تفصیلات';

  @override
  String get principalAmountLabel => 'اصل رقم';

  @override
  String get interestRateLabelFull => 'سود کی شرح';

  @override
  String get annualRateSuffix => 'سالانہ';

  @override
  String get tenureLabelFull => 'مدت';

  @override
  String get interestTypeLabel => 'سود کی قسم';

  @override
  String get startDateLabel => 'شروع کی تاریخ';

  @override
  String get monthlyEmiLabel => 'ماہانہ EMI';

  @override
  String get totalInterestLabel => 'کل سود';

  @override
  String get totalPayableLabel => 'کل قابل ادائیگی';

  @override
  String get loanStatusLabel => 'قرض کی حالت';

  @override
  String get loanIdLabel => 'قرض کی آئی ڈی';

  @override
  String get simpleInterestLabel => 'سادہ سود';

  @override
  String get compoundInterestLabel => 'مرکب سود';

  @override
  String get paymentSummaryTitle => 'ادائیگی کا خلاصہ';

  @override
  String get totalEmisLabel => 'کل EMIs';

  @override
  String get paidEmisLabel => 'ادا شدہ EMIs';

  @override
  String get pendingEmisLabel => 'زیر التواء EMIs';

  @override
  String get totalPaidLabel => 'کل ادا شدہ';

  @override
  String get totalPendingLabel => 'کل زیر التواء';

  @override
  String get totalLoanLabel => 'کل قرض';

  @override
  String get lenderSignature => 'قرض دہندہ کے دستخط';

  @override
  String get borrowerSignature => 'قرض لینے والے کے دستخط';

  @override
  String get dateLabel => 'تاریخ';

  @override
  String get footerText =>
      'یہ دستاویز کمپیوٹر سے تیار کردہ ہے اور توثیق کے لیے جسمانی دستخط کی ضرورت نہیں ہے۔';

  @override
  String get confidentialLabel => 'قرض مینجمنٹ سسٹم | خفیہ دستاویز';

  @override
  String get generatedLabel => 'تیار کردہ';

  @override
  String get docIdLabel => 'دستاویز کی آئی ڈی';

  @override
  String get lenderName => 'نام';

  @override
  String get lenderMobile => 'موبائل';

  @override
  String get lenderEmail => 'ای میل';

  @override
  String get lenderAddress => 'پتہ';

  @override
  String get lenderLicense => 'لائسنس نمبر';

  @override
  String get borrowerName => 'نام';

  @override
  String get borrowerMobile => 'موبائل';

  @override
  String get borrowerEmail => 'ای میل';

  @override
  String get borrowerLocation => 'مقام';

  @override
  String get searchHint => 'تلاش کریں...';

  @override
  String get clearSearch => 'صاف کریں';

  @override
  String get filter => 'فلٹر';

  @override
  String get allFilter => 'تمام';

  @override
  String get activeFilter => 'فعال';

  @override
  String get completedFilter => 'مکمل';

  @override
  String get noResults => 'کوئی نتیجہ نہیں ملا';

  @override
  String get loading => 'لوڈ ہو رہا ہے...';

  @override
  String get processing => 'کارروائی ہو رہی ہے...';

  @override
  String get pleaseWait => 'براہ کرم انتظار کریں...';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get errorOccurred => 'ایک خرابی پیش آئی';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get yes => 'ہاں';

  @override
  String get no => 'نہیں';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get officeAddress => 'دفتر کا پتہ';

  @override
  String get licenseNumber => 'لائسنس نمبر';

  @override
  String get saveChanges => 'تبدیلیاں محفوظ کریں';

  @override
  String get saving => 'محفوظ ہو رہا ہے...';

  @override
  String get unsavedChanges => 'آپ کے پاس غیر محفوظ شدہ تبدیلیاں ہیں';

  @override
  String get discardChanges => 'تبدیلیاں مسترد کریں؟';

  @override
  String get confirmDiscard =>
      'کیا آپ واقعی اپنی تبدیلیاں مسترد کرنا چاہتے ہیں؟';

  @override
  String get close => 'بند کریں';

  @override
  String get back => 'واپس';

  @override
  String get next => 'اگلا';

  @override
  String get previous => 'پچھلا';

  @override
  String get done => 'مکمل';

  @override
  String get submit => 'جمع کریں';

  @override
  String get continueAction => 'جاری رکھیں';

  @override
  String get skip => 'چھوڑیں';

  @override
  String get later => 'بعد میں';

  @override
  String get now => 'ابھی';

  @override
  String get today => 'آج';

  @override
  String get yesterday => 'کل';

  @override
  String get tomorrow => 'کل';

  @override
  String get thisWeek => 'اس ہفتے';

  @override
  String get thisMonth => 'اس مہینے';

  @override
  String get thisYear => 'اس سال';

  @override
  String get january => 'جنوری';

  @override
  String get february => 'فروری';

  @override
  String get march => 'مارچ';

  @override
  String get april => 'اپریل';

  @override
  String get may => 'مئی';

  @override
  String get june => 'جون';

  @override
  String get july => 'جولائی';

  @override
  String get august => 'اگست';

  @override
  String get september => 'ستمبر';

  @override
  String get october => 'اکتوبر';

  @override
  String get november => 'نومبر';

  @override
  String get december => 'دسمبر';

  @override
  String get monday => 'پیر';

  @override
  String get tuesday => 'منگل';

  @override
  String get wednesday => 'بدھ';

  @override
  String get thursday => 'جمعرات';

  @override
  String get friday => 'جمعہ';

  @override
  String get saturday => 'ہفتہ';

  @override
  String get sunday => 'اتوار';

  @override
  String get am => 'صبح';

  @override
  String get pm => 'شام';

  @override
  String get currencySymbol => '₹';

  @override
  String get currencyCode => 'INR';

  @override
  String get rupees => 'روپے';

  @override
  String get lakh => 'لاکھ';

  @override
  String get crore => 'کروڑ';

  @override
  String get thousand => 'ہزار';

  @override
  String get selectDate => 'تاریخ منتخب کریں';

  @override
  String get selectTime => 'وقت منتخب کریں';

  @override
  String get chooseOption => 'ایک اختیار منتخب کریں';

  @override
  String get requiredField => 'یہ فیلڈ درکار ہے';

  @override
  String get invalidInput => 'غلط ان پٹ';

  @override
  String minLength(Object count) {
    return 'کم از کم لمبائی $count حروف ہے';
  }

  @override
  String maxLength(Object count) {
    return 'زیادہ سے زیادہ لمبائی $count حروف ہے';
  }

  @override
  String get mustBeNumber => 'نمبر ہونا چاہیے';

  @override
  String get mustBePositive => 'مثبت نمبر ہونا چاہیے';

  @override
  String get mustBeInteger => 'مکمل نمبر ہونا چاہیے';

  @override
  String get emailAlreadyExists => 'ای میل پہلے سے موجود ہے';

  @override
  String get mobileAlreadyExists => 'موبائل نمبر پہلے سے موجود ہے';

  @override
  String get customerExists => 'گاہک پہلے سے موجود ہے';

  @override
  String get loanExists => 'قرض پہلے سے موجود ہے';

  @override
  String get documentExists => 'دستاویز پہلے سے موجود ہے';

  @override
  String get backupExists => 'بیک اپ پہلے سے موجود ہے';

  @override
  String get restoreWarning =>
      'یہ تمام موجودہ ڈیٹا کی جگہ لے گا۔ کیا آپ واقعی کرنا چاہتے ہیں؟';

  @override
  String get dataRestored => 'ڈیٹا کامیابی سے بحال ہو گیا!';

  @override
  String get dataBackupUp => 'ڈیٹا کامیابی سے بیک اپ ہو گیا!';

  @override
  String get mpinSetup => 'ایم-پن سیٹ کریں';

  @override
  String get confirmMpin => 'ایم-پن کی تصدیق کریں';

  @override
  String get mpinMismatch => 'ایم-پن میچ نہیں کرتے';

  @override
  String get mpinSet => 'ایم-پن کامیابی سے سیٹ ہو گیا!';

  @override
  String get mpinChanged => 'ایم-پن کامیابی سے تبدیل ہو گیا!';

  @override
  String get currentMpin => 'موجودہ ایم-پن';

  @override
  String get newMpin => 'نیا ایم-پن';

  @override
  String get changeMpin => 'ایم-پن تبدیل کریں';

  @override
  String get forgotMpin => 'ایم-پن بھول گئے؟';

  @override
  String get resetMpin => 'ایم-پن ری سیٹ کریں';

  @override
  String get verifyIdentity => 'شناخت کی تصدیق کریں';

  @override
  String get verificationCode => 'تصدیقی کوڈ';

  @override
  String get sendCode => 'کوڈ بھیجیں';

  @override
  String get verifyCode => 'کوڈ کی تصدیق کریں';

  @override
  String get codeSent => 'آپ کے رجسٹرڈ موبائل/ای میل پر کوڈ بھیجا گیا';

  @override
  String get invalidCode => 'غلط تصدیقی کوڈ';

  @override
  String get codeExpired => 'تصدیقی کوڈ کی میعاد ختم ہو گئی';

  @override
  String get resendCode => 'کوڈ دوبارہ بھیجیں';

  @override
  String get permissionsRequired => 'اجازتیں درکار ہیں';

  @override
  String get grantPermissions => 'براہ کرم مطلوبہ اجازتیں دیں';

  @override
  String get storagePermission => 'اسٹوریج اجازت درکار ہے';

  @override
  String get cameraPermission => 'کیمرہ اجازت درکار ہے';

  @override
  String get contactsPermission => 'رابطوں کی اجازت درکار ہے';

  @override
  String get locationPermission => 'مقام کی اجازت درکار ہے';

  @override
  String get notificationPermission => 'اطلاع کی اجازت درکار ہے';

  @override
  String get internetRequired => 'انٹرنیٹ کنکشن درکار ہے';

  @override
  String get offlineMode => 'آف لائن موڈ';

  @override
  String get dataSync => 'ڈیٹا سنک';

  @override
  String get syncNow => 'ابھی سنک کریں';

  @override
  String get lastSynced => 'آخری سنک';

  @override
  String get syncFailed => 'سنک ناکام';

  @override
  String get syncSuccess => 'سنک کامیاب';

  @override
  String get autoSync => 'خودکار سنک';

  @override
  String get wifiOnlySync => 'صرف Wi-Fi سنک';

  @override
  String get darkMode => 'ڈارک موڈ';

  @override
  String get lightMode => 'لائٹ موڈ';

  @override
  String get systemDefault => 'سسٹم ڈیفالٹ';

  @override
  String get theme => 'تھیم';

  @override
  String get fontSize => 'فونٹ سائز';

  @override
  String get smallFont => 'چھوٹا';

  @override
  String get mediumFont => 'درمیانہ';

  @override
  String get largeFont => 'بڑا';

  @override
  String get extraLargeFont => 'بہت بڑا';

  @override
  String get pushNotifications => 'پش اطلاعات';

  @override
  String get emailNotifications => 'ای میل اطلاعات';

  @override
  String get smsNotifications => 'SMS اطلاعات';

  @override
  String get reminderNotifications => 'یاد دہانی کی اطلاعات';

  @override
  String get paymentReminders => 'ادائیگی کی یاد دہانی';

  @override
  String get dueSoonReminders => 'جلد قابل ادائیگی یاد دہانی';

  @override
  String get overdueReminders => 'میعاد گزری یاد دہانی';

  @override
  String get marketingNotifications => 'مارکیٹنگ اطلاعات';

  @override
  String get privacyPolicy => 'رازداری کی پالیسی';

  @override
  String get termsOfService => 'سروس کی شرائط';

  @override
  String get aboutApp => 'ایپ کے بارے میں';

  @override
  String get contactSupport => 'سپورٹ سے رابطہ کریں';

  @override
  String get rateApp => 'ایپ کو ریٹ کریں';

  @override
  String get shareApp => 'ایپ شیئر کریں';

  @override
  String get feedback => 'رائے';

  @override
  String get reportBug => 'بگ کی اطلاع دیں';

  @override
  String get featureRequest => 'فیچر کی درخواست';

  @override
  String get helpCenter => 'مدد کا مرکز';

  @override
  String get faq => 'اکثر پوچھے جانے والے سوالات';

  @override
  String get userGuide => 'صارف گائیڈ';

  @override
  String get tutorial => 'ٹیوٹوریل';

  @override
  String get loanManagement => 'قرض کا انتظام';

  @override
  String get customerManagement => 'گاہک کا انتظام';

  @override
  String get paymentTracking => 'ادائیگی کی ٹریکنگ';

  @override
  String get documentGeneration => 'دستاویز کی تیاری';

  @override
  String get backupRestore => 'بیک اپ اور بحالی';

  @override
  String get multiLanguage => 'کثیر لسانی تعاون';

  @override
  String get secureData => 'محفوظ ڈیٹا';

  @override
  String get offlineAccess => 'آف لائن رسائی';

  @override
  String get quickActions => 'فوری اقدامات';

  @override
  String get recentActivity => 'حالیہ سرگرمی';

  @override
  String get noRecentActivity => 'کوئی حالیہ سرگرمی نہیں';

  @override
  String get viewAllActivity => 'تمام سرگرمی دیکھیں';

  @override
  String get dashboard => 'ڈیش بورڈ';

  @override
  String get overview => 'جائزہ';

  @override
  String get statistics => 'اعداد و شمار';

  @override
  String get reports => 'رپورٹس';

  @override
  String get analytics => 'تجزیات';

  @override
  String get exportData => 'ڈیٹا برآمد کریں';

  @override
  String get importData => 'ڈیٹا درآمد کریں';

  @override
  String get print => 'پرنٹ کریں';

  @override
  String get download => 'ڈاؤن لوڈ کریں';

  @override
  String get upload => 'اپ لوڈ کریں';

  @override
  String get attachFile => 'فائل منسلک کریں';

  @override
  String get removeFile => 'فائل ہٹائیں';

  @override
  String get noFileSelected => 'کوئی فائل منتخب نہیں';

  @override
  String get fileTooLarge => 'فائل بہت بڑی ہے';

  @override
  String get invalidFileType => 'غلط فائل کی قسم';

  @override
  String get uploading => 'اپ لوڈ ہو رہا ہے...';

  @override
  String get downloadComplete => 'ڈاؤن لوڈ مکمل';

  @override
  String get uploadComplete => 'اپ لوڈ مکمل';

  @override
  String get operationSuccess => 'کارروائی کامیاب!';

  @override
  String get operationFailed => 'کارروائی ناکام';

  @override
  String get unknownError => 'نامعلوم خرابی پیش آئی';

  @override
  String get networkError => 'نیٹ ورک کی خرابی';

  @override
  String get serverError => 'سرور کی خرابی';

  @override
  String get timeoutError => 'درخواست کا وقت ختم';

  @override
  String get unauthorized => 'غیر مجاز رسائی';

  @override
  String get forbidden => 'رسائی ممنوع';

  @override
  String get notFound => 'نہیں ملا';

  @override
  String get validationError => 'توثیق کی خرابی';

  @override
  String get duplicateEntry => 'نقل اندراج';

  @override
  String get constraintViolation => 'پابندی کی خلاف ورزی';

  @override
  String get databaseError => 'ڈیٹا بیس کی خرابی';

  @override
  String get connectionLost => 'کنکشن کھو گیا';

  @override
  String get reconnecting => 'دوبارہ جڑ رہا ہے...';

  @override
  String get online => 'آن لائن';

  @override
  String get offline => 'آف لائن';

  @override
  String get syncStatus => 'سنک کی حالت';

  @override
  String get lastSync => 'آخری سنک';

  @override
  String get autoSyncEnabled => 'خودکار سنک فعال';

  @override
  String get wifiOnly => 'صرف Wi-Fi';

  @override
  String get dataUsage => 'ڈیٹا کا استعمال';

  @override
  String get storageUsage => 'اسٹوریج کا استعمال';

  @override
  String get cacheSize => 'کیش کا سائز';

  @override
  String get clearCache => 'کیش صاف کریں';

  @override
  String get clearData => 'ڈیٹا صاف کریں';

  @override
  String get resetApp => 'ایپ ری سیٹ کریں';

  @override
  String get confirmReset =>
      'کیا آپ واقعی ایپ ری سیٹ کرنا چاہتے ہیں؟ تمام ڈیٹا ضائع ہو جائے گا۔';

  @override
  String get appReset => 'ایپ ری سیٹ ہو گئی ہے';

  @override
  String get logs => 'لاگز';

  @override
  String get viewLogs => 'لاگز دیکھیں';

  @override
  String get exportLogs => 'لاگز برآمد کریں';

  @override
  String get clearLogs => 'لاگز صاف کریں';

  @override
  String get debugMode => 'ڈیبگ موڈ';

  @override
  String get developerOptions => 'ڈویلپر کے اختیارات';

  @override
  String get versionCode => 'ورژن کوڈ';

  @override
  String get buildNumber => 'بلڈ نمبر';

  @override
  String get packageName => 'پیکیج کا نام';

  @override
  String get appSignature => 'ایپ کی دستخط';

  @override
  String get installSource => 'انسٹال کا ذریعہ';

  @override
  String get deviceInfo => 'ڈیوائس کی معلومات';

  @override
  String get osVersion => 'OS ورژن';

  @override
  String get deviceModel => 'ڈیوائس ماڈل';

  @override
  String get manufacturer => 'بنانے والا';

  @override
  String get screenResolution => 'اسکرین کی ریزولوشن';

  @override
  String get density => 'کثافت';

  @override
  String get totalStorage => 'کل اسٹوریج';

  @override
  String get availableStorage => 'دستیاب اسٹوریج';

  @override
  String get memoryUsage => 'میموری کا استعمال';

  @override
  String get cpuUsage => 'CPU کا استعمال';

  @override
  String get batteryLevel => 'بیٹری کی سطح';

  @override
  String get networkType => 'نیٹ ورک کی قسم';

  @override
  String get ipAddress => 'IP پتہ';

  @override
  String get macAddress => 'MAC پتہ';

  @override
  String get imei => 'IMEI';

  @override
  String get simOperator => 'SIM آپریٹر';

  @override
  String get phoneNumber => 'فون نمبر';

  @override
  String get countryCode => 'ملک کا کوڈ';

  @override
  String get timezone => 'ٹائم زون';

  @override
  String get locale => 'لوکیل';

  @override
  String get region => 'علاقہ';

  @override
  String get currency => 'کرنسی';

  @override
  String get dateFormat => 'تاریخ کی شکل';

  @override
  String get timeFormat => 'وقت کی شکل';

  @override
  String get weekStart => 'ہفتے کا آغاز';

  @override
  String get firstDayOfWeek => 'ہفتے کا پہلا دن';

  @override
  String get numberFormat => 'نمبر کی شکل';

  @override
  String get decimalSeparator => 'اعشاریہ جدا کرنے والا';

  @override
  String get thousandSeparator => 'ہزار جدا کرنے والا';

  @override
  String get listSeparator => 'فہرست جدا کرنے والا';

  @override
  String get measurementSystem => 'پیمائش کا نظام';

  @override
  String get metric => 'میٹرک';

  @override
  String get imperial => 'امپیریل';

  @override
  String get temperatureUnit => 'درجہ حرارت کی اکائی';

  @override
  String get celsius => 'سیلسیس';

  @override
  String get fahrenheit => 'فارن ہائٹ';

  @override
  String get windSpeedUnit => 'ہوا کی رفتار کی اکائی';

  @override
  String get pressureUnit => 'دباؤ کی اکائی';

  @override
  String get visibilityUnit => 'نظر کی اکائی';

  @override
  String get precipitationUnit => 'بارش کی اکائی';
}
