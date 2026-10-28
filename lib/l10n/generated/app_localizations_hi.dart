// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'ऋण प्रबंधन ऐप';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है';

  @override
  String get signInToAccess =>
      'अपने ऋण डैशबोर्ड तक पहुंचने के लिए साइन इन करें';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get enterFullName => 'अपना पूरा नाम दर्ज करें';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get enterMobileNumber => '10-अंकीय मोबाइल नंबर दर्ज करें';

  @override
  String get emailId => 'ईमेल आईडी';

  @override
  String get enterEmailAddress => 'अपना ईमेल पता दर्ज करें';

  @override
  String get mpin => 'एम-पिन (6 अंक)';

  @override
  String get enterMpin => 'अपना 6-अंकीय एम-पिन दर्ज करें';

  @override
  String get signIn => 'साइन इन';

  @override
  String get signingIn => 'साइन इन हो रहा है...';

  @override
  String get termsAndPrivacy =>
      'साइन इन करके, आप हमारी सेवा की शर्तों और गोपनीयता नीति से सहमत होते हैं';

  @override
  String get invalidName => 'कृपया अपना नाम दर्ज करें';

  @override
  String get nameTooShort => 'नाम कम से कम 2 अक्षरों का होना चाहिए';

  @override
  String get invalidMobile => 'कृपया अपना मोबाइल नंबर दर्ज करें';

  @override
  String get invalidMobileFormat =>
      'एक वैध 10-अंकीय भारतीय मोबाइल नंबर दर्ज करें';

  @override
  String get invalidEmail => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get invalidEmailFormat => 'एक वैध ईमेल पता दर्ज करें';

  @override
  String get invalidMpin => 'कृपया अपना एम-पिन दर्ज करें';

  @override
  String get invalidMpinFormat => 'एम-पिन ठीक 6 अंकों का होना चाहिए';

  @override
  String get nameLabel => 'पूरा नाम';

  @override
  String get mobileLabel => 'मोबाइल नंबर';

  @override
  String get emailLabel => 'ईमेल आईडी';

  @override
  String get mpinLabel => 'एम-पिन (6 अंक)';

  @override
  String get nameHint => 'ग्राहक का पूरा नाम दर्ज करें';

  @override
  String get mobileHint => '10-अंकीय मोबाइल नंबर दर्ज करें';

  @override
  String get emailHint => 'ग्राहक का ईमेल पता दर्ज करें';

  @override
  String get locationLabel => 'स्थान';

  @override
  String get locationHint => 'शहर, राज्य दर्ज करें (जैसे मुंबई, महाराष्ट्र)';

  @override
  String get invalidLocation => 'कृपया स्थान दर्ज करें';

  @override
  String get addCustomer => 'ग्राहक जोड़ें';

  @override
  String get editCustomer => 'ग्राहक संपादित करें';

  @override
  String get updateCustomer => 'ग्राहक अपडेट करें';

  @override
  String get deleteCustomer => 'ग्राहक हटाएं';

  @override
  String get customerAdded => 'ग्राहक सफलतापूर्वक जोड़ा गया!';

  @override
  String get customerUpdated => 'ग्राहक सफलतापूर्वक अपडेट किया गया!';

  @override
  String get confirmDeleteCustomer =>
      'क्या आप वाकई इस ग्राहक को हटाना चाहते हैं? इससे संबंधित सभी ऋण और ईएमआई भी हट जाएंगे।';

  @override
  String get customers => 'ग्राहक';

  @override
  String get searchCustomers => 'नाम, मोबाइल या ईमेल से खोजें';

  @override
  String get noCustomersFound => 'कोई ग्राहक नहीं मिला';

  @override
  String get noCustomersYet => 'अभी तक कोई ग्राहक नहीं';

  @override
  String get addFirstCustomer => 'शुरू करने के लिए अपना पहला ग्राहक जोड़ें';

  @override
  String get tryDifferentSearch => 'एक अलग खोज शब्द आज़माएं';

  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get createLoan => 'ऋण बनाएं';

  @override
  String get customerFound => 'ग्राहक मिला';

  @override
  String get customerNotFound => 'ग्राहक नहीं मिला';

  @override
  String get noCustomerRegistered =>
      'इस मोबाइल नंबर से कोई ग्राहक पंजीकृत नहीं है।';

  @override
  String get addNewCustomer => 'नया ग्राहक जोड़ें';

  @override
  String get findCustomer => 'ग्राहक खोजें';

  @override
  String get searchByMobile => 'ऋण बनाने के लिए मोबाइल नंबर से खोजें';

  @override
  String get enterMobileToSearch => '10-अंकीय मोबाइल नंबर दर्ज करें';

  @override
  String get loanAmount => 'ऋण राशि (₹)';

  @override
  String get enterLoanAmount => 'मूल राशि दर्ज करें';

  @override
  String get interestRate => 'ब्याज दर (% वार्षिक)';

  @override
  String get enterInterestRate => 'उदाहरण, 10.5';

  @override
  String get tenureMonths => 'अवधि (महीने)';

  @override
  String get enterTenure => 'उदाहरण, 24';

  @override
  String get interestType => 'ब्याज प्रकार';

  @override
  String get simpleInterest => 'साधारण ब्याज';

  @override
  String get simpleInterestDesc => 'ब्याज केवल मूलधन पर गणना किया जाता है';

  @override
  String get compoundInterest => 'चक्रवृद्धि ब्याज';

  @override
  String get compoundInterestDesc =>
      'ब्याज मूलधन + संचित ब्याज पर गणना किया जाता है';

  @override
  String get emiPreview => 'ईएमआई पूर्वावलोकन';

  @override
  String get monthlyEmi => 'मासिक ईएमआई';

  @override
  String get totalInterest => 'कुल ब्याज';

  @override
  String get totalPayable => 'कुल देय';

  @override
  String get createLoanButton => 'ऋण बनाएं';

  @override
  String get loanCreated => 'ऋण सफलतापूर्वक बनाया गया! ईएमआई जनरेट हो गई हैं।';

  @override
  String get invalidAmount => 'कृपया ऋण राशि दर्ज करें';

  @override
  String get invalidAmountValue => 'एक वैध राशि दर्ज करें';

  @override
  String get invalidRate => 'आवश्यक';

  @override
  String get invalidRateValue => 'वैध दर दर्ज करें (1-50%)';

  @override
  String get invalidTenure => 'आवश्यक';

  @override
  String get invalidTenureValue => 'वैध अवधि दर्ज करें (1-360)';

  @override
  String get loans => 'ऋण';

  @override
  String get searchLoans => 'ऋण खोजें...';

  @override
  String get searchByLoanId => 'ऋण आईडी, ग्राहक नाम या मोबाइल से खोजें';

  @override
  String get noLoansFound => 'कोई ऋण नहीं मिला';

  @override
  String get noLoansYet => 'अभी तक कोई ऋण नहीं';

  @override
  String get createFirstLoan => 'शुरू करने के लिए अपना पहला ऋण बनाएं';

  @override
  String get tryDifferentSearchOrFilter => 'एक अलग खोज शब्द या फ़िल्टर आज़माएं';

  @override
  String get allLoans => 'सभी ऋण';

  @override
  String get activeOnly => 'केवल सक्रिय';

  @override
  String get completedOnly => 'केवल पूर्ण';

  @override
  String get payEmi => 'ईएमआई भुगतान';

  @override
  String get viewPdf => 'पीडीएफ देखें';

  @override
  String get loanDetails => 'ऋण विवरण';

  @override
  String get principalAmount => 'मूल राशि';

  @override
  String get totalAmount => 'कुल राशि';

  @override
  String get interestRateLabel => 'ब्याज दर';

  @override
  String get tenureLabel => 'अवधि';

  @override
  String get progress => 'प्रगति';

  @override
  String get paid => 'भुगतान किया गया';

  @override
  String get pending => 'लंबित';

  @override
  String get overdue => 'विलंबित';

  @override
  String get nextEmi => 'अगली ईएमआई';

  @override
  String get due => 'देय';

  @override
  String get emiPayments => 'ईएमआई भुगतान';

  @override
  String get loanSummary => 'ऋण सारांश';

  @override
  String get repaymentProgress => 'पुनर्भुगतान प्रगति';

  @override
  String get completed => 'पूर्ण';

  @override
  String get payNow => 'अभी भुगतान करें';

  @override
  String get payAllPending => 'सभी लंबित ईएमआई का भुगतान करें';

  @override
  String confirmPayEmi(Object installmentNumber) {
    return 'ईएमआई #$installmentNumber का भुगतान करें?';
  }

  @override
  String confirmPayAll(Object count) {
    return '$count लंबित ईएमआई का एक साथ भुगतान करें?';
  }

  @override
  String get amount => 'राशि';

  @override
  String get dueDate => 'देय तिथि';

  @override
  String get totalAmountLabel => 'कुल राशि';

  @override
  String get allEmisPaid => 'सभी ईएमआई सफलतापूर्वक भुगतान की गईं!';

  @override
  String get paymentConfirmation => 'भुगतान पुष्टिकरण';

  @override
  String get paying => 'भुगतान हो रहा है...';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get paymentMethod => 'भुगतान विधि';

  @override
  String get cash => 'नकद';

  @override
  String get cheque => 'चेक';

  @override
  String emiPaidOn(Object date) {
    return '$date को भुगतान किया गया';
  }

  @override
  String get emiOverdue => 'विलंबित';

  @override
  String get emiPending => 'लंबित';

  @override
  String get emiPaid => 'भुगतान किया गया';

  @override
  String get installment => 'किस्त क्रमांक';

  @override
  String get emiAmount => 'ईएमआई राशि';

  @override
  String get status => 'स्थिति';

  @override
  String get paidDate => 'भुगतान तिथि';

  @override
  String get emiSchedule => 'ईएमआई भुगतान अनुसूची';

  @override
  String get loanOverview => 'ऋण अवलोकन';

  @override
  String get totalLoans => 'कुल ऋण';

  @override
  String get emiDue => 'ईएमआई देय';

  @override
  String get totalCustomers => 'कुल ग्राहक';

  @override
  String get documentsGenerated => 'दस्तावेज़ जनरेट किए गए';

  @override
  String get activeLoans => 'सक्रिय ऋण';

  @override
  String get recentLoans => 'हाल के ऋण';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'शुभ दोपहर';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String languageChanged(Object languageName) {
    return 'भाषा $languageName में अपडेट की गई';
  }

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get tamil => 'तमिल';

  @override
  String get telugu => 'तेलुगु';

  @override
  String get bengali => 'बंगाली';

  @override
  String get marathi => 'मराठी';

  @override
  String get gujarati => 'गुजराती';

  @override
  String get kannada => 'कन्नड़';

  @override
  String get malayalam => 'मलयालम';

  @override
  String get punjabi => 'पंजाबी';

  @override
  String get odia => 'ओड़िया';

  @override
  String get urdu => 'उर्दू';

  @override
  String get assamese => 'असमिया';

  @override
  String get backup => 'बैकअप';

  @override
  String get restore => 'पुनर्स्थापित करें';

  @override
  String get encryptedBackup => 'एन्क्रिप्टेड बैकअप';

  @override
  String get encryptedRestore => 'एन्क्रिप्टेड पुनर्स्थापना';

  @override
  String get backupNow => 'अभी बैकअप लें';

  @override
  String get connectAndBackup => 'कनेक्ट करें और बैकअप लें';

  @override
  String get backupCompleted =>
      'बैकअप सफलतापूर्वक पूरा हुआ! एन्क्रिप्टेड और Google Drive ऐप डेटा में संग्रहीत।';

  @override
  String get backupFailed => 'बैकअप विफल';

  @override
  String get restoreCompleted =>
      'डेटा सफलतापूर्वक पुनर्स्थापित! कृपया एक नया एम-पिन सेट करें।';

  @override
  String get restoreFailed => 'पुनर्स्थापना विफल - डेटा दूषित हो सकता है';

  @override
  String get invalidPassword => 'अमान्य पासवर्ड या कोई बैकअप नहीं मिला';

  @override
  String get passwordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 8 अक्षरों का होना चाहिए';

  @override
  String get backupPassword => 'बैकअप पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get enterBackupPassword => 'एक मजबूत पासवर्ड दर्ज करें';

  @override
  String get reEnterPassword => 'पासवर्ड दोबारा दर्ज करें';

  @override
  String get passwordWarning =>
      'महत्वपूर्ण: यह पासवर्ड आपके बैकअप को एन्क्रिप्ट करता है। यदि आप इसे भूल जाते हैं, तो आपका डेटा पुनर्प्राप्त नहीं किया जा सकता। Google मदद नहीं कर सकता। इसे लिख लें और सुरक्षित रखें।';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get signedOut => 'Google Drive से साइन आउट किया गया';

  @override
  String get connectedToGoogleDrive => 'Google Drive से कनेक्टेड';

  @override
  String get notConnected => 'कनेक्टेड नहीं';

  @override
  String get signInWithGoogle =>
      'एन्क्रिप्टेड बैकअप बनाने के लिए अपने Google खाते से साइन इन करें। आपका डेटा अपलोड से पहले आपके डिवाइस पर AES-256-GCM से एन्क्रिप्ट किया जाता है। Google आपका अनएन्क्रिप्टेड डेटा कभी नहीं देखता।';

  @override
  String get recentBackups => 'हाल के बैकअप (अधिकतम 5 रखे गए)';

  @override
  String get maxBackups => 'अधिकतम 5 बैकअप';

  @override
  String get maxBackupsDesc =>
      'केवल 5 सबसे हाल के बैकअप रखे जाते हैं। पुराने ऑटो-डिलीट हो जाते हैं।';

  @override
  String get securityNotes => 'सुरक्षा नोट्स';

  @override
  String get encryptionInfo =>
      'आपका डेटा अपलोड से पहले आपके डिवाइस पर AES-256-GCM से एन्क्रिप्ट किया जाता है। कुंजी आपके पासवर्ड से PBKDF2 (200,000 राउंड) का उपयोग करके प्राप्त की जाती है।';

  @override
  String get passwordNotStored =>
      'ऐप कभी भी आपके बैकअप पासवर्ड को संग्रहीत नहीं करता। यदि आप इसे भूल जाते हैं, तो आपका बैकअप डिक्रिप्ट नहीं किया जा सकता। न आप द्वारा, न Google द्वारा, न हमारे द्वारा।';

  @override
  String get hiddenFolder =>
      'बैकअप Google Drive के छिपे हुए \"ऐप डेटा\" फ़ोल्डर में जाते हैं। आप उन्हें Drive में नहीं देख सकते, और कोई अन्य ऐप उन्हें एक्सेस नहीं कर सकता।';

  @override
  String get lmbkFormat =>
      'बैकअप कस्टम LMBK फॉर्मेट का उपयोग करते हैं: मैजिक बाइट्स + संस्करण + साल्ट + IV + एन्क्रिप्टेड डेटा + ऑथ टैग।';

  @override
  String get mpinNotBackedUp =>
      'आपका एम-पिन जानबूझकर बैकअप से बाहर रखा गया है। पुनर्स्थापना के बाद, आपको एक नया एम-पिन सेट करना होगा।';

  @override
  String get onlineOnly =>
      'बैकअप/पुनर्स्थापना के लिए इंटरनेट आवश्यक है। ऐप का बाकी हिस्सा पूरी तरह ऑफ़लाइन काम करता है।';

  @override
  String get appInformation => 'ऐप जानकारी';

  @override
  String get appVersion => 'ऐप संस्करण';

  @override
  String get dataStorage => 'डेटा संग्रहण';

  @override
  String get backupFormat => 'बैकअप फॉर्मेट';

  @override
  String get backupLocation => 'बैकअप स्थान';

  @override
  String get lastBackup => 'अंतिम बैकअप';

  @override
  String get localStorage => 'स्थानीय (SharedPreferences)';

  @override
  String get backupFormatDesc => 'LMBK v1 (AES-256-GCM)';

  @override
  String get backupLocationDesc => 'Google Drive ऐप डेटा फ़ोल्डर';

  @override
  String get never => 'कभी नहीं';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get view => 'देखें';

  @override
  String get regenerate => 'पुनर्जनरेट करें';

  @override
  String get share => 'साझा करें';

  @override
  String get pdfGenerated => 'पीडीएफ जनरेट हुआ';

  @override
  String get viewPdfButton => 'पीडीएफ देखें';

  @override
  String get shareButton => 'साझा करें';

  @override
  String get editRegenerate => 'संपादित/पुनर्जनरेट';

  @override
  String get deleteButton => 'हटाएं';

  @override
  String get pdfOptions => 'पीडीएफ विकल्प';

  @override
  String get choosePdfLanguage => 'PDF की भाषा चुनें';

  @override
  String selectedPdfLanguage(Object languageName) {
    return 'चयनित ऐप भाषा का उपयोग करें ($languageName)';
  }

  @override
  String get pdfSystemHeading => 'ऋण प्रबंधन प्रणाली';

  @override
  String get pdfAgreementSubtitle => 'ऋण समझौता और भुगतान सारांश';

  @override
  String get monthsCount => 'महीने';

  @override
  String get smartFinancialSolutions => 'स्मार्ट वित्तीय समाधान';

  @override
  String get backupYourData => 'अपने डेटा का बैकअप लें';

  @override
  String get backupYourDataDescription =>
      'Google Drive पर बैकअप लेकर अपने ऋण डेटा को सुरक्षित रखें। ऐप को फिर से इंस्टॉल करने के बाद भी आप इसे कभी भी पुनर्स्थापित कर सकते हैं।';

  @override
  String get profileUpdated => 'प्रोफ़ाइल सफलतापूर्वक अपडेट की गई!';

  @override
  String get lenderDetails => 'ऋणदाता का विवरण';

  @override
  String get missingPdfData => 'PDF बनाने के लिए आवश्यक डेटा उपलब्ध नहीं है';

  @override
  String get deleteDocumentTitle => 'दस्तावेज़ हटाएं';

  @override
  String get confirmDeletePdf =>
      'क्या आप वाकई इस PDF दस्तावेज़ को हटाना चाहते हैं?';

  @override
  String get documentDeleted => 'दस्तावेज़ हटा दिया गया';

  @override
  String get groupedByCustomer => 'ग्राहक के अनुसार समूहित';

  @override
  String get noCustomerForMobile =>
      'इस मोबाइल नंबर से कोई ग्राहक पंजीकृत नहीं है।\nकृपया पहले ग्राहक जोड़ें।';

  @override
  String get customerDeleted => 'ग्राहक सफलतापूर्वक हटाया गया!';

  @override
  String get confirmPayment => 'भुगतान की पुष्टि करें';

  @override
  String get amountColon => 'राशि:';

  @override
  String get dueDateColon => 'देय तिथि:';

  @override
  String get totalAmountColon => 'कुल राशि:';

  @override
  String get payAll => 'सभी का भुगतान करें';

  @override
  String get backupPasswordPrompt =>
      'बैकअप बनाते समय इस्तेमाल किया गया पासवर्ड दर्ज करें।';

  @override
  String get restoreEncryptedBackup =>
      'एन्क्रिप्टेड बैकअप से पुनर्स्थापित करें';

  @override
  String get restoreGoogleAccountInstruction =>
      'उसी Google खाते से साइन इन करें। आपको बैकअप के समय सेट किया गया पासवर्ड चाहिए होगा। पुनर्स्थापना के बाद नया M-PIN सेट करना आवश्यक है (सुरक्षा के लिए M-PIN बैकअप में संग्रहीत नहीं होता)।';

  @override
  String get appLanguage => 'ऐप की भाषा';

  @override
  String get choosePreferredLanguage => 'अपनी पसंदीदा भाषा चुनें';

  @override
  String get customerDeletedToast => 'ग्राहक हटा दिया गया';

  @override
  String get documents => 'दस्तावेज़';

  @override
  String get loanDocuments => 'ऋण दस्तावेज़';

  @override
  String get allDocuments => 'सभी दस्तावेज़';

  @override
  String get noDocumentsFound => 'कोई दस्तावेज़ नहीं मिला';

  @override
  String get completeEmisForPdf =>
      'ऋण समझौता पीडीएफ जनरेट करने के लिए सभी ईएमआई भुगतान पूरे करें';

  @override
  String get docsAppearAfterLoan =>
      'दस्तावेज़ ऋण पूरा होने के बाद यहां दिखाई देंगे';

  @override
  String get backToLoans => 'ऋण पर वापस जाएं';

  @override
  String get pdfGeneratedSuccess => 'पीडीएफ जनरेट हुआ';

  @override
  String get customerDetails => 'ग्राहक विवरण';

  @override
  String get loanAmountLabel => 'ऋण राशि';

  @override
  String get emisPaid => 'भुगतान की गई ईएमआई';

  @override
  String get totalLabel => 'कुल';

  @override
  String get viewPdfAction => 'पीडीएफ देखें';

  @override
  String get shareAction => 'साझा करें';

  @override
  String get regenerateAction => 'पुनर्जनरेट करें';

  @override
  String get deleteAction => 'हटाएं';

  @override
  String get viewPdfActionShort => 'पीडीएफ देखें';

  @override
  String get shareActionShort => 'साझा करें';

  @override
  String get editAction => 'पुनर्जनरेट करें';

  @override
  String get deleteActionShort => 'हटाएं';

  @override
  String get paymentSummary => 'भुगतान सारांश';

  @override
  String get totalEmis => 'कुल ईएमआई';

  @override
  String get paidEmis => 'भुगतान की गई ईएमआई';

  @override
  String get pendingEmis => 'लंबित ईएमआई';

  @override
  String get totalPaid => 'कुल भुगतान';

  @override
  String get totalPending => 'कुल लंबित';

  @override
  String get totalLoan => 'कुल ऋण';

  @override
  String get emiScheduleTitle => 'ईएमआई भुगतान अनुसूची';

  @override
  String get installmentHeader => 'किस्त क्रमांक';

  @override
  String get dueDateHeader => 'देय तिथि';

  @override
  String get emiAmountHeader => 'ईएमआई राशि';

  @override
  String get statusHeader => 'स्थिति';

  @override
  String get paidDateHeader => 'भुगतान तिथि';

  @override
  String get loanAgreementTitle => 'ऋण समझौता';

  @override
  String get partiesTitle => 'समझौते के पक्षकार';

  @override
  String get lenderLabel => 'ऋणदाता';

  @override
  String get borrowerLabel => 'उधारकर्ता';

  @override
  String get mobileLabelShort => 'मोबाइल';

  @override
  String get emailLabelShort => 'ईमेल';

  @override
  String get addressLabel => 'पता';

  @override
  String get licenseLabel => 'लाइसेंस नं.';

  @override
  String get locationLabelShort => 'स्थान';

  @override
  String get loanDetailsTitle => 'ऋण विवरण';

  @override
  String get principalAmountLabel => 'मूल ऋण राशि';

  @override
  String get interestRateLabelFull => 'ब्याज दर';

  @override
  String get tenureLabelFull => 'ऋण की अवधि';

  @override
  String get interestTypeLabel => 'ब्याज का प्रकार';

  @override
  String get startDateLabel => 'प्रारंभ तिथि';

  @override
  String get monthlyEmiLabel => 'मासिक ईएमआई';

  @override
  String get totalInterestLabel => 'कुल ब्याज';

  @override
  String get totalPayableLabel => 'कुल देय राशि';

  @override
  String get loanStatusLabel => 'ऋण की स्थिति';

  @override
  String get loanIdLabel => 'ऋण आईडी';

  @override
  String get simpleInterestLabel => 'साधारण ब्याज';

  @override
  String get compoundInterestLabel => 'चक्रवृद्धि ब्याज';

  @override
  String get paymentSummaryTitle => 'भुगतान सारांश';

  @override
  String get totalEmisLabel => 'कुल ईएमआई';

  @override
  String get paidEmisLabel => 'भुगतान की गई ईएमआई';

  @override
  String get pendingEmisLabel => 'लंबित ईएमआई';

  @override
  String get totalPaidLabel => 'कुल भुगतान';

  @override
  String get totalPendingLabel => 'कुल लंबित';

  @override
  String get totalLoanLabel => 'कुल ऋण';

  @override
  String get lenderSignature => 'ऋणदाता हस्ताक्षर';

  @override
  String get borrowerSignature => 'उधारकर्ता हस्ताक्षर';

  @override
  String get dateLabel => 'तिथि';

  @override
  String get footerText =>
      'यह दस्तावेज़ कंप्यूटर द्वारा तैयार किया गया है। इसकी पुष्टि के लिए भौतिक हस्ताक्षर की आवश्यकता नहीं है।';

  @override
  String get confidentialLabel => 'ऋण प्रबंधन प्रणाली | गोपनीय दस्तावेज़';

  @override
  String get generatedLabel => 'जनरेट किया गया';

  @override
  String get docIdLabel => 'दस्तावेज़ आईडी';

  @override
  String get lenderName => 'नाम';

  @override
  String get lenderMobile => 'मोबाइल';

  @override
  String get lenderEmail => 'ईमेल';

  @override
  String get lenderAddress => 'पता';

  @override
  String get lenderLicense => 'लाइसेंस नं.';

  @override
  String get borrowerName => 'नाम';

  @override
  String get borrowerMobile => 'मोबाइल';

  @override
  String get borrowerEmail => 'ईमेल';

  @override
  String get borrowerLocation => 'स्थान';

  @override
  String get searchHint => 'खोजें...';

  @override
  String get clearSearch => 'साफ़ करें';

  @override
  String get filter => 'फ़िल्टर';

  @override
  String get allFilter => 'सभी';

  @override
  String get activeFilter => 'सक्रिय';

  @override
  String get completedFilter => 'पूर्ण';

  @override
  String get noResults => 'कोई परिणाम नहीं मिला';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get processing => 'प्रोसेसिंग...';

  @override
  String get pleaseWait => 'कृपया प्रतीक्षा करें...';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get errorOccurred => 'एक त्रुटि हुई';

  @override
  String get tryAgain => 'फिर से आज़माएं';

  @override
  String get ok => 'ठीक है';

  @override
  String get yes => 'हां';

  @override
  String get no => 'नहीं';

  @override
  String get save => 'सहेजें';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get saving => 'सहेजा जा रहा है...';

  @override
  String get unsavedChanges => 'आपके पास असहेजे परिवर्तन हैं';

  @override
  String get discardChanges => 'परिवर्तन छोड़ें?';

  @override
  String get confirmDiscard => 'क्या आप वाकई अपने परिवर्तन छोड़ना चाहते हैं?';

  @override
  String get close => 'बंद करें';

  @override
  String get back => 'वापस';

  @override
  String get next => 'अगला';

  @override
  String get previous => 'पिछला';

  @override
  String get done => 'हो गया';

  @override
  String get submit => 'जमा करें';

  @override
  String get continueAction => 'जारी रखें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get later => 'बाद में';

  @override
  String get now => 'अभी';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get tomorrow => 'कल';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get thisYear => 'इस वर्ष';

  @override
  String get january => 'जनवरी';

  @override
  String get february => 'फरवरी';

  @override
  String get march => 'मार्च';

  @override
  String get april => 'अप्रैल';

  @override
  String get may => 'मई';

  @override
  String get june => 'जून';

  @override
  String get july => 'जुलाई';

  @override
  String get august => 'अगस्त';

  @override
  String get september => 'सितंबर';

  @override
  String get october => 'अक्टूबर';

  @override
  String get november => 'नवंबर';

  @override
  String get december => 'दिसंबर';

  @override
  String get monday => 'सोमवार';

  @override
  String get tuesday => 'मंगलवार';

  @override
  String get wednesday => 'बुधवार';

  @override
  String get thursday => 'गुरुवार';

  @override
  String get friday => 'शुक्रवार';

  @override
  String get saturday => 'शनिवार';

  @override
  String get sunday => 'रविवार';

  @override
  String get am => 'पूर्वाह्न';

  @override
  String get pm => 'अपराह्न';

  @override
  String get currencySymbol => '₹';

  @override
  String get currencyCode => 'INR';

  @override
  String get rupees => '₹';

  @override
  String get lakh => 'लाख';

  @override
  String get crore => 'करोड़';

  @override
  String get thousand => 'हज़ार';

  @override
  String get selectDate => 'तिथि चुनें';

  @override
  String get selectTime => 'समय चुनें';

  @override
  String get chooseOption => 'एक विकल्प चुनें';

  @override
  String get requiredField => 'यह फ़ील्ड आवश्यक है';

  @override
  String get invalidInput => 'अमान्य इनपुट';

  @override
  String minLength(Object count) {
    return 'न्यूनतम लंबाई $count अक्षर है';
  }

  @override
  String maxLength(Object count) {
    return 'अधिकतम लंबाई $count अक्षर है';
  }

  @override
  String get mustBeNumber => 'संख्या होनी चाहिए';

  @override
  String get mustBePositive => 'धनात्मक संख्या होनी चाहिए';

  @override
  String get mustBeInteger => 'पूर्णांक होना चाहिए';

  @override
  String get emailAlreadyExists => 'ईमेल पहले से मौजूद है';

  @override
  String get mobileAlreadyExists => 'मोबाइल नंबर पहले से मौजूद है';

  @override
  String get customerExists => 'ग्राहक पहले से मौजूद है';

  @override
  String get loanExists => 'ऋण पहले से मौजूद है';

  @override
  String get documentExists => 'दस्तावेज़ पहले से मौजूद है';

  @override
  String get backupExists => 'बैकअप पहले से मौजूद है';

  @override
  String get restoreWarning =>
      'यह सभी वर्तमान डेटा को बदल देगा। क्या आप निश्चित हैं?';

  @override
  String get dataRestored => 'डेटा सफलतापूर्वक पुनर्स्थापित!';

  @override
  String get dataBackupUp => 'डेटा सफलतापूर्वक बैकअप किया गया!';

  @override
  String get mpinSetup => 'एम-पिन सेट करें';

  @override
  String get confirmMpin => 'एम-पिन की पुष्टि करें';

  @override
  String get mpinMismatch => 'एम-पिन मेल नहीं खाते';

  @override
  String get mpinSet => 'एम-पिन सफलतापूर्वक सेट किया गया!';

  @override
  String get mpinChanged => 'एम-पिन सफलतापूर्वक बदला गया!';

  @override
  String get currentMpin => 'वर्तमान एम-पिन';

  @override
  String get newMpin => 'नया एम-पिन';

  @override
  String get changeMpin => 'एम-पिन बदलें';

  @override
  String get forgotMpin => 'एम-पिन भूल गए?';

  @override
  String get resetMpin => 'एम-पिन रीसेट करें';

  @override
  String get verifyIdentity => 'पहचान सत्यापित करें';

  @override
  String get verificationCode => 'सत्यापन कोड';

  @override
  String get sendCode => 'कोड भेजें';

  @override
  String get verifyCode => 'कोड सत्यापित करें';

  @override
  String get codeSent => 'कोड आपके पंजीकृत मोबाइल/ईमेल पर भेजा गया';

  @override
  String get invalidCode => 'अमान्य सत्यापन कोड';

  @override
  String get codeExpired => 'सत्यापन कोड समाप्त हो गया';

  @override
  String get resendCode => 'कोड पुनः भेजें';

  @override
  String get permissionsRequired => 'अनुमतियां आवश्यक';

  @override
  String get grantPermissions => 'कृपया आवश्यक अनुमतियां दें';

  @override
  String get storagePermission => 'स्टोरेज अनुमति आवश्यक';

  @override
  String get cameraPermission => 'कैमरा अनुमति आवश्यक';

  @override
  String get contactsPermission => 'संपर्क अनुमति आवश्यक';

  @override
  String get locationPermission => 'स्थान अनुमति आवश्यक';

  @override
  String get notificationPermission => 'सूचना अनुमति आवश्यक';

  @override
  String get internetRequired => 'इंटरनेट कनेक्शन आवश्यक';

  @override
  String get offlineMode => 'ऑफ़लाइन मोड';

  @override
  String get dataSync => 'डेटा सिंक';

  @override
  String get syncNow => 'अभी सिंक करें';

  @override
  String get lastSynced => 'अंतिम सिंक';

  @override
  String get syncFailed => 'सिंक विफल';

  @override
  String get syncSuccess => 'सिंक सफल';

  @override
  String get autoSync => 'ऑटो सिंक';

  @override
  String get wifiOnlySync => 'केवल वाई-फाई सिंक';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get lightMode => 'लाइट मोड';

  @override
  String get systemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get theme => 'थीम';

  @override
  String get fontSize => 'फ़ॉन्ट आकार';

  @override
  String get smallFont => 'छोटा';

  @override
  String get mediumFont => 'मध्यम';

  @override
  String get largeFont => 'बड़ा';

  @override
  String get extraLargeFont => 'अतिरिक्त बड़ा';

  @override
  String get pushNotifications => 'पुश सूचनाएं';

  @override
  String get emailNotifications => 'ईमेल सूचनाएं';

  @override
  String get smsNotifications => 'एसएमएस सूचनाएं';

  @override
  String get reminderNotifications => 'रिमाइंडर सूचनाएं';

  @override
  String get paymentReminders => 'भुगतान रिमाइंडर';

  @override
  String get dueSoonReminders => 'जल्द देय रिमाइंडर';

  @override
  String get overdueReminders => 'विलंबित रिमाइंडर';

  @override
  String get marketingNotifications => 'मार्केटिंग सूचनाएं';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get contactSupport => 'सहायता से संपर्क करें';

  @override
  String get rateApp => 'ऐप को रेट करें';

  @override
  String get shareApp => 'ऐप साझा करें';

  @override
  String get feedback => 'प्रतिक्रिया';

  @override
  String get reportBug => 'बग रिपोर्ट करें';

  @override
  String get featureRequest => 'फीचर अनुरोध';

  @override
  String get helpCenter => 'सहायता केंद्र';

  @override
  String get faq => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get userGuide => 'उपयोगकर्ता गाइड';

  @override
  String get tutorial => 'ट्यूटोरियल';

  @override
  String get loanManagement => 'ऋण प्रबंधन';

  @override
  String get customerManagement => 'ग्राहक प्रबंधन';

  @override
  String get paymentTracking => 'भुगतान ट्रैकिंग';

  @override
  String get documentGeneration => 'दस्तावेज़ जनरेशन';

  @override
  String get backupRestore => 'बैकअप और पुनर्स्थापना';

  @override
  String get multiLanguage => 'बहु-भाषा समर्थन';

  @override
  String get secureData => 'सुरक्षित डेटा';

  @override
  String get offlineAccess => 'ऑफ़लाइन एक्सेस';

  @override
  String get quickActions => 'त्वरित क्रियाएं';

  @override
  String get recentActivity => 'हाल की गतिविधि';

  @override
  String get noRecentActivity => 'कोई हाल की गतिविधि नहीं';

  @override
  String get viewAllActivity => 'सभी गतिविधि देखें';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get overview => 'अवलोकन';

  @override
  String get statistics => 'आंकड़े';

  @override
  String get reports => 'रिपोर्ट';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get exportData => 'डेटा निर्यात करें';

  @override
  String get importData => 'डेटा आयात करें';

  @override
  String get print => 'प्रिंट';

  @override
  String get download => 'डाउनलोड';

  @override
  String get upload => 'अपलोड';

  @override
  String get attachFile => 'फ़ाइल संलग्न करें';

  @override
  String get removeFile => 'फ़ाइल हटाएं';

  @override
  String get noFileSelected => 'कोई फ़ाइल चयनित नहीं';

  @override
  String get fileTooLarge => 'फ़ाइल बहुत बड़ी';

  @override
  String get invalidFileType => 'अमान्य फ़ाइल प्रकार';

  @override
  String get uploading => 'अपलोड हो रहा है...';

  @override
  String get downloadComplete => 'डाउनलोड पूरा';

  @override
  String get uploadComplete => 'अपलोड पूरा';

  @override
  String get operationSuccess => 'ऑपरेशन सफल!';

  @override
  String get operationFailed => 'ऑपरेशन विफल';

  @override
  String get unknownError => 'अज्ञात त्रुटि हुई';

  @override
  String get networkError => 'नेटवर्क त्रुटि';

  @override
  String get serverError => 'सर्वर त्रुटि';

  @override
  String get timeoutError => 'अनुरोध टाइमआउट';

  @override
  String get unauthorized => 'अनधिकृत पहुंच';

  @override
  String get forbidden => 'पहुंच निषिद्ध';

  @override
  String get notFound => 'नहीं मिला';

  @override
  String get validationError => 'सत्यापन त्रुटि';

  @override
  String get duplicateEntry => 'डुप्लिकेट प्रविष्टि';

  @override
  String get constraintViolation => 'बाधा उल्लंघन';

  @override
  String get databaseError => 'डेटाबेस त्रुटि';

  @override
  String get connectionLost => 'कनेक्शन खो गया';

  @override
  String get reconnecting => 'पुनः कनेक्ट हो रहा है...';

  @override
  String get online => 'ऑनलाइन';

  @override
  String get offline => 'ऑफ़लाइन';

  @override
  String get syncStatus => 'सिंक स्थिति';

  @override
  String get lastSync => 'अंतिम सिंक';

  @override
  String get autoSyncEnabled => 'ऑटो सिंक सक्षम';

  @override
  String get wifiOnly => 'केवल वाई-फाई';

  @override
  String get dataUsage => 'डेटा उपयोग';

  @override
  String get storageUsage => 'संग्रहण उपयोग';

  @override
  String get cacheSize => 'कैश आकार';

  @override
  String get clearCache => 'कैश साफ़ करें';

  @override
  String get clearData => 'डेटा साफ़ करें';

  @override
  String get resetApp => 'ऐप रीसेट करें';

  @override
  String get confirmReset =>
      'क्या आप वाकई ऐप को रीसेट करना चाहते हैं? सभी डेटा खो जाएगा।';

  @override
  String get appReset => 'ऐप रीसेट हो गया है';

  @override
  String get logs => 'लॉग';

  @override
  String get viewLogs => 'लॉग देखें';

  @override
  String get exportLogs => 'लॉग निर्यात करें';

  @override
  String get clearLogs => 'लॉग साफ़ करें';

  @override
  String get debugMode => 'डिबग मोड';

  @override
  String get developerOptions => 'डेवलपर विकल्प';

  @override
  String get versionCode => 'संस्करण कोड';

  @override
  String get buildNumber => 'बिल्ड नंबर';

  @override
  String get packageName => 'पैकेज नाम';

  @override
  String get appSignature => 'ऐप हस्ताक्षर';

  @override
  String get installSource => 'इंस्टॉल स्रोत';

  @override
  String get deviceInfo => 'डिवाइस जानकारी';

  @override
  String get osVersion => 'OS संस्करण';

  @override
  String get deviceModel => 'डिवाइस मॉडल';

  @override
  String get manufacturer => 'निर्माता';

  @override
  String get screenResolution => 'स्क्रीन रिज़ॉल्यूशन';

  @override
  String get density => 'घनत्व';

  @override
  String get totalStorage => 'कुल संग्रहण';

  @override
  String get availableStorage => 'उपलब्ध संग्रहण';

  @override
  String get memoryUsage => 'मेमोरी उपयोग';

  @override
  String get cpuUsage => 'CPU उपयोग';

  @override
  String get batteryLevel => 'बैटरी स्तर';

  @override
  String get networkType => 'नेटवर्क प्रकार';

  @override
  String get ipAddress => 'IP पता';

  @override
  String get macAddress => 'MAC पता';

  @override
  String get imei => 'IMEI';

  @override
  String get simOperator => 'सिम ऑपरेटर';

  @override
  String get phoneNumber => 'फोन नंबर';

  @override
  String get countryCode => 'देश कोड';

  @override
  String get timezone => 'समय क्षेत्र';

  @override
  String get locale => 'लोकेल';

  @override
  String get region => 'क्षेत्र';

  @override
  String get currency => 'मुद्रा';

  @override
  String get dateFormat => 'दिनांक प्रारूप';

  @override
  String get timeFormat => 'समय प्रारूप';

  @override
  String get weekStart => 'सप्ताह प्रारंभ';

  @override
  String get firstDayOfWeek => 'सप्ताह का पहला दिन';

  @override
  String get numberFormat => 'संख्या प्रारूप';

  @override
  String get decimalSeparator => 'दशमलव विभाजक';

  @override
  String get thousandSeparator => 'हज़ार विभाजक';

  @override
  String get listSeparator => 'सूची विभाजक';

  @override
  String get measurementSystem => 'माप प्रणाली';

  @override
  String get metric => 'मीट्रिक';

  @override
  String get imperial => 'इम्पीरियल';

  @override
  String get temperatureUnit => 'तापमान इकाई';

  @override
  String get celsius => 'सेल्सियस';

  @override
  String get fahrenheit => 'फ़ारेनहाइट';

  @override
  String get windSpeedUnit => 'हवा की गति इकाई';

  @override
  String get pressureUnit => 'दबाव इकाई';

  @override
  String get visibilityUnit => 'दृश्यता इकाई';

  @override
  String get precipitationUnit => 'वर्षा इकाई';
}
