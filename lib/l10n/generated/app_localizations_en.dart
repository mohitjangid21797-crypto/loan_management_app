// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Loan Management App';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToAccess => 'Sign in to access your loan dashboard';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get enterMobileNumber => 'Enter 10-digit mobile number';

  @override
  String get emailId => 'Email ID';

  @override
  String get enterEmailAddress => 'Enter your email address';

  @override
  String get mpin => 'M-PIN (6 Digit)';

  @override
  String get enterMpin => 'Enter your 6-digit M-PIN';

  @override
  String get signIn => 'Sign In';

  @override
  String get signingIn => 'Signing In...';

  @override
  String get termsAndPrivacy =>
      'By signing in, you agree to our Terms of Service and Privacy Policy';

  @override
  String get invalidName => 'Please enter your name';

  @override
  String get nameTooShort => 'Name must be at least 2 characters';

  @override
  String get invalidMobile => 'Please enter your mobile number';

  @override
  String get invalidMobileFormat =>
      'Enter a valid 10-digit Indian mobile number';

  @override
  String get invalidEmail => 'Please enter your email';

  @override
  String get invalidEmailFormat => 'Enter a valid email address';

  @override
  String get invalidMpin => 'Please enter your M-PIN';

  @override
  String get invalidMpinFormat => 'M-PIN must be exactly 6 digits';

  @override
  String get nameLabel => 'Full Name';

  @override
  String get mobileLabel => 'Mobile Number';

  @override
  String get emailLabel => 'Email ID';

  @override
  String get mpinLabel => 'M-PIN (6 Digit)';

  @override
  String get nameHint => 'Enter customer\'s full name';

  @override
  String get mobileHint => 'Enter 10-digit mobile number';

  @override
  String get emailHint => 'Enter customer\'s email address';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationHint => 'Enter city, state (e.g., Mumbai, Maharashtra)';

  @override
  String get invalidLocation => 'Please enter location';

  @override
  String get addCustomer => 'Add Customer';

  @override
  String get editCustomer => 'Edit Customer';

  @override
  String get updateCustomer => 'Update Customer';

  @override
  String get deleteCustomer => 'Delete Customer';

  @override
  String get customerAdded => 'Customer added successfully!';

  @override
  String get customerUpdated => 'Customer updated successfully!';

  @override
  String get confirmDeleteCustomer =>
      'Are you sure you want to delete this customer? This will also delete all associated loans and EMIs.';

  @override
  String get customers => 'Customers';

  @override
  String get searchCustomers => 'Search by name, mobile, or email';

  @override
  String get noCustomersFound => 'No Customers Found';

  @override
  String get noCustomersYet => 'No Customers Yet';

  @override
  String get addFirstCustomer => 'Add your first customer to get started';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get viewDetails => 'View Details';

  @override
  String get createLoan => 'Create Loan';

  @override
  String get customerFound => 'Customer Found';

  @override
  String get customerNotFound => 'Customer Not Found';

  @override
  String get noCustomerRegistered =>
      'No customer registered with this mobile number.';

  @override
  String get addNewCustomer => 'Add New Customer';

  @override
  String get findCustomer => 'Find Customer';

  @override
  String get searchByMobile => 'Search by mobile number to create loan';

  @override
  String get enterMobileToSearch => 'Enter 10-digit mobile number';

  @override
  String get loanAmount => 'Loan Amount (₹)';

  @override
  String get enterLoanAmount => 'Enter principal amount';

  @override
  String get interestRate => 'Interest Rate (% p.a.)';

  @override
  String get enterInterestRate => 'e.g., 10.5';

  @override
  String get tenureMonths => 'Tenure (Months)';

  @override
  String get enterTenure => 'e.g., 24';

  @override
  String get interestType => 'Interest Type';

  @override
  String get simpleInterest => 'Simple Interest';

  @override
  String get simpleInterestDesc => 'Interest calculated on principal only';

  @override
  String get compoundInterest => 'Compound Interest';

  @override
  String get compoundInterestDesc =>
      'Interest calculated on principal + accumulated interest';

  @override
  String get emiPreview => 'EMI Preview';

  @override
  String get monthlyEmi => 'Monthly EMI';

  @override
  String get totalInterest => 'Total Interest';

  @override
  String get totalPayable => 'Total Payable';

  @override
  String get createLoanButton => 'Create Loan';

  @override
  String get loanCreated => 'Loan created successfully! EMIs generated.';

  @override
  String get invalidAmount => 'Please enter loan amount';

  @override
  String get invalidAmountValue => 'Enter a valid amount';

  @override
  String get invalidRate => 'Required';

  @override
  String get invalidRateValue => 'Enter valid rate (1-50%)';

  @override
  String get invalidTenure => 'Required';

  @override
  String get invalidTenureValue => 'Enter valid tenure (1-360)';

  @override
  String get loans => 'Loans';

  @override
  String get searchLoans => 'Search loans...';

  @override
  String get searchByLoanId => 'Search by loan ID, customer name, or mobile';

  @override
  String get noLoansFound => 'No Loans Found';

  @override
  String get noLoansYet => 'No Loans Yet';

  @override
  String get createFirstLoan => 'Create your first loan to get started';

  @override
  String get tryDifferentSearchOrFilter =>
      'Try a different search term or filter';

  @override
  String get allLoans => 'All Loans';

  @override
  String get activeOnly => 'Active Only';

  @override
  String get completedOnly => 'Completed Only';

  @override
  String get payEmi => 'Pay EMI';

  @override
  String get viewPdf => 'View PDF';

  @override
  String get loanDetails => 'Loan Details';

  @override
  String get principalAmount => 'Principal Amount';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get interestRateLabel => 'Interest Rate';

  @override
  String get tenureLabel => 'Tenure';

  @override
  String get progress => 'Progress';

  @override
  String get paid => 'Paid';

  @override
  String get pending => 'Pending';

  @override
  String get overdue => 'Overdue';

  @override
  String get nextEmi => 'Next EMI';

  @override
  String get due => 'Due';

  @override
  String get emiPayments => 'EMI Payments';

  @override
  String get loanSummary => 'Loan Summary';

  @override
  String get repaymentProgress => 'Repayment Progress';

  @override
  String get completed => 'Completed';

  @override
  String get payNow => 'Pay Now';

  @override
  String get payAllPending => 'Pay All Pending EMIs';

  @override
  String confirmPayEmi(Object installmentNumber) {
    return 'Pay EMI #$installmentNumber?';
  }

  @override
  String confirmPayAll(Object count) {
    return 'Pay $count pending EMIs at once?';
  }

  @override
  String get amount => 'Amount';

  @override
  String get dueDate => 'Due Date';

  @override
  String get totalAmountLabel => 'Total Amount';

  @override
  String get allEmisPaid => 'All EMIs paid successfully!';

  @override
  String get paymentConfirmation => 'Payment Confirmation';

  @override
  String get paying => 'Paying...';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get cash => 'Cash';

  @override
  String get cheque => 'Cheque';

  @override
  String emiPaidOn(Object date) {
    return 'Paid on $date';
  }

  @override
  String get emiOverdue => 'Overdue';

  @override
  String get emiPending => 'Pending';

  @override
  String get emiPaid => 'Paid';

  @override
  String get installment => 'Inst. #';

  @override
  String get emiAmount => 'EMI Amount';

  @override
  String get status => 'Status';

  @override
  String get paidDate => 'Paid Date';

  @override
  String get emiSchedule => 'EMI Schedule';

  @override
  String get loanOverview => 'Loan Overview';

  @override
  String get totalLoans => 'Total Loans';

  @override
  String get emiDue => 'EMI Due';

  @override
  String get totalCustomers => 'Total Customers';

  @override
  String get documentsGenerated => 'Documents Generated';

  @override
  String get activeLoans => 'Active Loans';

  @override
  String get recentLoans => 'Recent Loans';

  @override
  String get viewAll => 'View All';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String languageChanged(Object languageName) {
    return 'Language updated to $languageName';
  }

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get tamil => 'Tamil';

  @override
  String get telugu => 'Telugu';

  @override
  String get bengali => 'Bengali';

  @override
  String get marathi => 'Marathi';

  @override
  String get gujarati => 'Gujarati';

  @override
  String get kannada => 'Kannada';

  @override
  String get malayalam => 'Malayalam';

  @override
  String get punjabi => 'Punjabi';

  @override
  String get odia => 'Odia';

  @override
  String get urdu => 'Urdu';

  @override
  String get assamese => 'Assamese';

  @override
  String get backup => 'Backup';

  @override
  String get restore => 'Restore';

  @override
  String get encryptedBackup => 'Encrypted Backup';

  @override
  String get encryptedRestore => 'Encrypted Restore';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get connectAndBackup => 'Connect & Backup';

  @override
  String get backupCompleted =>
      'Backup completed successfully! Encrypted and stored in Google Drive app data.';

  @override
  String get backupFailed => 'Backup failed';

  @override
  String get restoreCompleted =>
      'Data restored successfully! Please set a new M-PIN.';

  @override
  String get restoreFailed => 'Restore failed - data may be corrupted';

  @override
  String get invalidPassword => 'Invalid password or no backup found';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get backupPassword => 'Backup Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterBackupPassword => 'Enter a strong password';

  @override
  String get reEnterPassword => 'Re-enter password';

  @override
  String get passwordWarning =>
      'IMPORTANT: This password encrypts your backup. If you forget it, your data CANNOT be recovered. Google cannot help. Write it down and store it safely.';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signedOut => 'Signed out from Google Drive';

  @override
  String get connectedToGoogleDrive => 'Connected to Google Drive';

  @override
  String get notConnected => 'Not Connected';

  @override
  String get signInWithGoogle =>
      'Sign in with your Google account to create an encrypted backup. Your data is encrypted on your device with AES-256-GCM before upload. Google never sees your unencrypted data.';

  @override
  String get recentBackups => 'Recent Backups (max 5 kept)';

  @override
  String get maxBackups => 'Max 5 Backups';

  @override
  String get maxBackupsDesc =>
      'Only the 5 most recent backups are kept. Older ones are auto-deleted.';

  @override
  String get securityNotes => 'Security Notes';

  @override
  String get encryptionInfo =>
      'Your data is encrypted with AES-256-GCM on your device before upload. The key is derived from your password using PBKDF2 (200,000 rounds).';

  @override
  String get passwordNotStored =>
      'The app never stores your backup password. If you forget it, your backup CANNOT be decrypted. Not by you, not by Google, not by us.';

  @override
  String get hiddenFolder =>
      'Backups go to Google Drive\'s hidden \"app data\" folder. You cannot see them in Drive, and no other app can access them.';

  @override
  String get lmbkFormat =>
      'Backups use custom LMBK format: magic bytes + version + salt + IV + encrypted data + auth tag.';

  @override
  String get mpinNotBackedUp =>
      'Your M-PIN is deliberately excluded from backups. After restore, you must set a new M-PIN.';

  @override
  String get onlineOnly =>
      'Backup/restore require internet. The rest of the app works fully offline.';

  @override
  String get appInformation => 'App Information';

  @override
  String get appVersion => 'App Version';

  @override
  String get dataStorage => 'Data Storage';

  @override
  String get backupFormat => 'Backup Format';

  @override
  String get backupLocation => 'Backup Location';

  @override
  String get lastBackup => 'Last Backup';

  @override
  String get localStorage => 'Local (SQLite database)';

  @override
  String get backupFormatDesc => 'LMBK v2 (AES-256-GCM)';

  @override
  String get backupLocationDesc => 'Google Drive App Data Folder';

  @override
  String get never => 'Never';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get view => 'View';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get share => 'Share';

  @override
  String get pdfGenerated => 'PDF Generated';

  @override
  String get viewPdfButton => 'View PDF';

  @override
  String get shareButton => 'Share';

  @override
  String get editRegenerate => 'Edit/Regenerate';

  @override
  String get deleteButton => 'Delete';

  @override
  String get pdfOptions => 'PDF Options';

  @override
  String get choosePdfLanguage => 'Choose PDF language';

  @override
  String selectedPdfLanguage(Object languageName) {
    return 'Use selected app language ($languageName)';
  }

  @override
  String get pdfSystemHeading => 'LOAN MANAGEMENT SYSTEM';

  @override
  String get pdfAgreementSubtitle => 'Loan Agreement & Payment Summary';

  @override
  String get monthsCount => 'Months';

  @override
  String get smartFinancialSolutions => 'Smart Financial Solutions';

  @override
  String get backupYourData => 'Backup Your Data';

  @override
  String get backupYourDataDescription =>
      'Secure your loan data by backing it up to Google Drive. You can restore it anytime, even after reinstalling the app.';

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get lenderDetails => 'Lender Details';

  @override
  String get missingPdfData => 'Missing data to generate PDF';

  @override
  String get deleteDocumentTitle => 'Delete Document';

  @override
  String get confirmDeletePdf =>
      'Are you sure you want to delete this PDF document?';

  @override
  String get documentDeleted => 'Document deleted';

  @override
  String get groupedByCustomer => 'Grouped by Customer';

  @override
  String get noCustomerForMobile =>
      'No customer registered with this mobile number.\nPlease add the customer first.';

  @override
  String get customerDeleted => 'Customer deleted successfully!';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String get amountColon => 'Amount:';

  @override
  String get dueDateColon => 'Due Date:';

  @override
  String get totalAmountColon => 'Total Amount:';

  @override
  String get payAll => 'Pay All';

  @override
  String get backupPasswordPrompt =>
      'Enter the password you used when creating this backup.';

  @override
  String get restoreEncryptedBackup => 'Restore from Encrypted Backup';

  @override
  String get restoreGoogleAccountInstruction =>
      'Sign in with the same Google account. You will need the backup password you set during backup. After restore, you must set a new M-PIN (M-PIN is not stored in backups for security).';

  @override
  String get appLanguage => 'App Language';

  @override
  String get choosePreferredLanguage => 'Choose your preferred language';

  @override
  String get customerDeletedToast => 'Customer deleted';

  @override
  String get documents => 'Documents';

  @override
  String get loanDocuments => 'Loan Documents';

  @override
  String get allDocuments => 'All Documents';

  @override
  String get noDocumentsFound => 'No Documents Found';

  @override
  String get completeEmisForPdf =>
      'Complete all EMI payments to generate loan agreement PDF';

  @override
  String get docsAppearAfterLoan =>
      'Documents will appear here after loan completion';

  @override
  String get backToLoans => 'Back to Loans';

  @override
  String get pdfGeneratedSuccess => 'PDF Generated';

  @override
  String get customerDetails => 'Customer Details';

  @override
  String get loanAmountLabel => 'Loan Amount';

  @override
  String get emisPaid => 'EMIs Paid';

  @override
  String get totalLabel => 'Total';

  @override
  String get viewPdfAction => 'View PDF';

  @override
  String get shareAction => 'Share';

  @override
  String get regenerateAction => 'Regenerate';

  @override
  String get deleteAction => 'Delete';

  @override
  String get viewPdfActionShort => 'View PDF';

  @override
  String get shareActionShort => 'Share';

  @override
  String get editAction => 'Regenerate';

  @override
  String get deleteActionShort => 'Delete';

  @override
  String get paymentSummary => 'Payment Summary';

  @override
  String get totalEmis => 'Total EMIs';

  @override
  String get paidEmis => 'Paid EMIs';

  @override
  String get pendingEmis => 'Pending EMIs';

  @override
  String get totalPaid => 'Total Paid';

  @override
  String get totalPending => 'Total Pending';

  @override
  String get totalLoan => 'Total Loan';

  @override
  String get emiScheduleTitle => 'EMI Schedule';

  @override
  String get installmentHeader => 'Inst. #';

  @override
  String get dueDateHeader => 'Due Date';

  @override
  String get emiAmountHeader => 'EMI Amount';

  @override
  String get statusHeader => 'Status';

  @override
  String get paidDateHeader => 'Paid Date';

  @override
  String get loanAgreementTitle => 'LOAN AGREEMENT';

  @override
  String get partiesTitle => 'PARTIES TO THE AGREEMENT';

  @override
  String get lenderLabel => 'LENDER';

  @override
  String get borrowerLabel => 'BORROWER';

  @override
  String get mobileLabelShort => 'Mobile';

  @override
  String get emailLabelShort => 'Email';

  @override
  String get addressLabel => 'Address';

  @override
  String get licenseLabel => 'License No';

  @override
  String get locationLabelShort => 'Location';

  @override
  String get loanDetailsTitle => 'LOAN DETAILS';

  @override
  String get principalAmountLabel => 'Principal Amount';

  @override
  String get interestRateLabelFull => 'Interest Rate';

  @override
  String get annualRateSuffix => 'p.a.';

  @override
  String get tenureLabelFull => 'Tenure';

  @override
  String get interestTypeLabel => 'Interest Type';

  @override
  String get startDateLabel => 'Start Date';

  @override
  String get monthlyEmiLabel => 'Monthly EMI';

  @override
  String get totalInterestLabel => 'Total Interest';

  @override
  String get totalPayableLabel => 'Total Payable';

  @override
  String get loanStatusLabel => 'Loan Status';

  @override
  String get loanIdLabel => 'Loan ID';

  @override
  String get simpleInterestLabel => 'Simple Interest';

  @override
  String get compoundInterestLabel => 'Compound Interest';

  @override
  String get paymentSummaryTitle => 'PAYMENT SUMMARY';

  @override
  String get totalEmisLabel => 'Total EMIs';

  @override
  String get paidEmisLabel => 'Paid EMIs';

  @override
  String get pendingEmisLabel => 'Pending EMIs';

  @override
  String get totalPaidLabel => 'Total Paid';

  @override
  String get totalPendingLabel => 'Total Pending';

  @override
  String get totalLoanLabel => 'Total Loan';

  @override
  String get lenderSignature => 'Lender Signature';

  @override
  String get borrowerSignature => 'Borrower Signature';

  @override
  String get dateLabel => 'Date';

  @override
  String get footerText =>
      'This document is computer-generated and does not require physical signature for validation.';

  @override
  String get confidentialLabel =>
      'Loan Management System | Confidential Document';

  @override
  String get generatedLabel => 'Generated';

  @override
  String get docIdLabel => 'Doc ID';

  @override
  String get lenderName => 'Name';

  @override
  String get lenderMobile => 'Mobile';

  @override
  String get lenderEmail => 'Email';

  @override
  String get lenderAddress => 'Address';

  @override
  String get lenderLicense => 'License No';

  @override
  String get borrowerName => 'Name';

  @override
  String get borrowerMobile => 'Mobile';

  @override
  String get borrowerEmail => 'Email';

  @override
  String get borrowerLocation => 'Location';

  @override
  String get searchHint => 'Search...';

  @override
  String get clearSearch => 'Clear';

  @override
  String get filter => 'Filter';

  @override
  String get allFilter => 'All';

  @override
  String get activeFilter => 'Active';

  @override
  String get completedFilter => 'Completed';

  @override
  String get noResults => 'No results found';

  @override
  String get loading => 'Loading...';

  @override
  String get processing => 'Processing...';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get retry => 'Retry';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get tryAgain => 'Try again';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get save => 'Save';

  @override
  String get officeAddress => 'Office Address';

  @override
  String get licenseNumber => 'License Number';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saving => 'Saving...';

  @override
  String get unsavedChanges => 'You have unsaved changes';

  @override
  String get discardChanges => 'Discard changes?';

  @override
  String get confirmDiscard => 'Are you sure you want to discard your changes?';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get submit => 'Submit';

  @override
  String get continueAction => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get later => 'Later';

  @override
  String get now => 'Now';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get currencySymbol => 'Rs.';

  @override
  String get currencyCode => 'INR';

  @override
  String get rupees => 'Rs.';

  @override
  String get lakh => 'L';

  @override
  String get crore => 'Cr';

  @override
  String get thousand => 'K';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTime => 'Select Time';

  @override
  String get chooseOption => 'Choose an option';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String minLength(Object count) {
    return 'Minimum length is $count characters';
  }

  @override
  String maxLength(Object count) {
    return 'Maximum length is $count characters';
  }

  @override
  String get mustBeNumber => 'Must be a number';

  @override
  String get mustBePositive => 'Must be a positive number';

  @override
  String get mustBeInteger => 'Must be a whole number';

  @override
  String get emailAlreadyExists => 'Email already exists';

  @override
  String get mobileAlreadyExists => 'Mobile number already exists';

  @override
  String get customerExists => 'Customer already exists';

  @override
  String get loanExists => 'Loan already exists';

  @override
  String get documentExists => 'Document already exists';

  @override
  String get backupExists => 'Backup already exists';

  @override
  String get restoreWarning =>
      'This will replace all current data. Are you sure?';

  @override
  String get dataRestored => 'Data restored successfully!';

  @override
  String get dataBackupUp => 'Data backed up successfully!';

  @override
  String get mpinSetup => 'Set M-PIN';

  @override
  String get confirmMpin => 'Confirm M-PIN';

  @override
  String get mpinMismatch => 'M-PINs do not match';

  @override
  String get mpinSet => 'M-PIN set successfully!';

  @override
  String get mpinChanged => 'M-PIN changed successfully!';

  @override
  String get currentMpin => 'Current M-PIN';

  @override
  String get newMpin => 'New M-PIN';

  @override
  String get changeMpin => 'Change M-PIN';

  @override
  String get forgotMpin => 'Forgot M-PIN?';

  @override
  String get resetMpin => 'Reset M-PIN';

  @override
  String get verifyIdentity => 'Verify Identity';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get sendCode => 'Send Code';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get codeSent => 'Code sent to your registered mobile/email';

  @override
  String get invalidCode => 'Invalid verification code';

  @override
  String get codeExpired => 'Verification code expired';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get permissionsRequired => 'Permissions required';

  @override
  String get grantPermissions => 'Please grant the required permissions';

  @override
  String get storagePermission => 'Storage permission required';

  @override
  String get cameraPermission => 'Camera permission required';

  @override
  String get contactsPermission => 'Contacts permission required';

  @override
  String get locationPermission => 'Location permission required';

  @override
  String get notificationPermission => 'Notification permission required';

  @override
  String get internetRequired => 'Internet connection required';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get dataSync => 'Data Sync';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get lastSynced => 'Last synced';

  @override
  String get syncFailed => 'Sync failed';

  @override
  String get syncSuccess => 'Sync successful';

  @override
  String get autoSync => 'Auto Sync';

  @override
  String get wifiOnlySync => 'Wi-Fi Only Sync';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get theme => 'Theme';

  @override
  String get fontSize => 'Font Size';

  @override
  String get smallFont => 'Small';

  @override
  String get mediumFont => 'Medium';

  @override
  String get largeFont => 'Large';

  @override
  String get extraLargeFont => 'Extra Large';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get smsNotifications => 'SMS Notifications';

  @override
  String get reminderNotifications => 'Reminder Notifications';

  @override
  String get paymentReminders => 'Payment Reminders';

  @override
  String get dueSoonReminders => 'Due Soon Reminders';

  @override
  String get overdueReminders => 'Overdue Reminders';

  @override
  String get marketingNotifications => 'Marketing Notifications';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get aboutApp => 'About App';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get rateApp => 'Rate App';

  @override
  String get shareApp => 'Share App';

  @override
  String get feedback => 'Feedback';

  @override
  String get reportBug => 'Report a Bug';

  @override
  String get featureRequest => 'Feature Request';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get faq => 'FAQ';

  @override
  String get userGuide => 'User Guide';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get loanManagement => 'Loan Management';

  @override
  String get customerManagement => 'Customer Management';

  @override
  String get paymentTracking => 'Payment Tracking';

  @override
  String get documentGeneration => 'Document Generation';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String get multiLanguage => 'Multi-Language Support';

  @override
  String get secureData => 'Secure Data';

  @override
  String get offlineAccess => 'Offline Access';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get viewAllActivity => 'View All Activity';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get overview => 'Overview';

  @override
  String get statistics => 'Statistics';

  @override
  String get reports => 'Reports';

  @override
  String get analytics => 'Analytics';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get print => 'Print';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get attachFile => 'Attach File';

  @override
  String get removeFile => 'Remove File';

  @override
  String get noFileSelected => 'No file selected';

  @override
  String get fileTooLarge => 'File too large';

  @override
  String get invalidFileType => 'Invalid file type';

  @override
  String get uploading => 'Uploading...';

  @override
  String get downloadComplete => 'Download complete';

  @override
  String get uploadComplete => 'Upload complete';

  @override
  String get operationSuccess => 'Operation successful!';

  @override
  String get operationFailed => 'Operation failed';

  @override
  String get unknownError => 'Unknown error occurred';

  @override
  String get networkError => 'Network error';

  @override
  String get serverError => 'Server error';

  @override
  String get timeoutError => 'Request timeout';

  @override
  String get unauthorized => 'Unauthorized access';

  @override
  String get forbidden => 'Access forbidden';

  @override
  String get notFound => 'Not found';

  @override
  String get validationError => 'Validation error';

  @override
  String get duplicateEntry => 'Duplicate entry';

  @override
  String get constraintViolation => 'Constraint violation';

  @override
  String get databaseError => 'Database error';

  @override
  String get connectionLost => 'Connection lost';

  @override
  String get reconnecting => 'Reconnecting...';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get syncStatus => 'Sync Status';

  @override
  String get lastSync => 'Last Sync';

  @override
  String get autoSyncEnabled => 'Auto Sync Enabled';

  @override
  String get wifiOnly => 'Wi-Fi Only';

  @override
  String get dataUsage => 'Data Usage';

  @override
  String get storageUsage => 'Storage Usage';

  @override
  String get cacheSize => 'Cache Size';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearData => 'Clear Data';

  @override
  String get resetApp => 'Reset App';

  @override
  String get confirmReset =>
      'Are you sure you want to reset the app? All data will be lost.';

  @override
  String get appReset => 'App has been reset';

  @override
  String get logs => 'Logs';

  @override
  String get viewLogs => 'View Logs';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get clearLogs => 'Clear Logs';

  @override
  String get debugMode => 'Debug Mode';

  @override
  String get developerOptions => 'Developer Options';

  @override
  String get versionCode => 'Version Code';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get packageName => 'Package Name';

  @override
  String get appSignature => 'App Signature';

  @override
  String get installSource => 'Install Source';

  @override
  String get deviceInfo => 'Device Info';

  @override
  String get osVersion => 'OS Version';

  @override
  String get deviceModel => 'Device Model';

  @override
  String get manufacturer => 'Manufacturer';

  @override
  String get screenResolution => 'Screen Resolution';

  @override
  String get density => 'Density';

  @override
  String get totalStorage => 'Total Storage';

  @override
  String get availableStorage => 'Available Storage';

  @override
  String get memoryUsage => 'Memory Usage';

  @override
  String get cpuUsage => 'CPU Usage';

  @override
  String get batteryLevel => 'Battery Level';

  @override
  String get networkType => 'Network Type';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get macAddress => 'MAC Address';

  @override
  String get imei => 'IMEI';

  @override
  String get simOperator => 'SIM Operator';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get countryCode => 'Country Code';

  @override
  String get timezone => 'Timezone';

  @override
  String get locale => 'Locale';

  @override
  String get region => 'Region';

  @override
  String get currency => 'Currency';

  @override
  String get dateFormat => 'Date Format';

  @override
  String get timeFormat => 'Time Format';

  @override
  String get weekStart => 'Week Start';

  @override
  String get firstDayOfWeek => 'First Day of Week';

  @override
  String get numberFormat => 'Number Format';

  @override
  String get decimalSeparator => 'Decimal Separator';

  @override
  String get thousandSeparator => 'Thousand Separator';

  @override
  String get listSeparator => 'List Separator';

  @override
  String get measurementSystem => 'Measurement System';

  @override
  String get metric => 'Metric';

  @override
  String get imperial => 'Imperial';

  @override
  String get temperatureUnit => 'Temperature Unit';

  @override
  String get celsius => 'Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';

  @override
  String get windSpeedUnit => 'Wind Speed Unit';

  @override
  String get pressureUnit => 'Pressure Unit';

  @override
  String get visibilityUnit => 'Visibility Unit';

  @override
  String get precipitationUnit => 'Precipitation Unit';
}
