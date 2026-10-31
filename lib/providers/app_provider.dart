import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/index.dart';
import '../services/app_database.dart';

class AppProvider extends ChangeNotifier {
  final AppDatabase database;
  Lender? _lender;
  final List<Customer> _customers = [];
  final List<Loan> _loans = [];
  final List<EMI> _emis = [];
  final List<LoanDocument> _documents = [];

  AppProvider({AppDatabase? database})
    : database = database ?? AppDatabase.instance;

  Lender? get lender => _lender;
  List<Customer> get customers => List.unmodifiable(_customers);
  List<Loan> get loans => List.unmodifiable(_loans);
  List<EMI> get emis => List.unmodifiable(_emis);
  List<LoanDocument> get documents => List.unmodifiable(_documents);

  Customer? getCustomerByMobile(String mobile) {
    final query = mobile.replaceAll(RegExp(r'\D'), '');
    if (query.length < 10) return null;
    final normalizedQuery = query.substring(query.length - 10);
    for (final customer in _customers) {
      final customerMobile = customer.mobileNumber.replaceAll(RegExp(r'\D'), '');
      if (customerMobile.length >= 10 &&
          customerMobile.substring(customerMobile.length - 10) == normalizedQuery) {
        return customer;
      }
    }
    return null;
  }

  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Loan> getLoansByCustomer(String customerId) {
    return _loans.where((l) => l.customerId == customerId).toList();
  }

  List<EMI> getEMIsByLoan(String loanId) {
    return _emis.where((e) => e.loanId == loanId).toList();
  }

  List<EMI> getPendingEMIsByLoan(String loanId) {
    return _emis.where((e) => e.loanId == loanId && e.status == EMIStatus.pending).toList();
  }

  Loan? getLoanById(String id) {
    try {
      return _loans.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  LoanDocument? getDocumentById(String id) {
    try {
      return _documents.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> initialize() async {
    await _loadFromStorage();
    if (_lender == null) {
      await _createDefaultLender();
    }
    notifyListeners();
  }

  Future<void> _createDefaultLender() async {
    _lender = Lender(
      name: 'John Doe',
      mobileNumber: '9876543210',
      email: 'john.doe@loanmanagement.com',
      address: '123 Finance Street, Mumbai, Maharashtra 400001',
      licenseNumber: 'LM-2024-001',
    );
    await _saveToStorage();
  }

  Future<void> updateLender(Lender lender) async {
    _lender = lender;
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    _customers.add(customer);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> replaceAllData({
    required Lender? lender,
    required List<Customer> customers,
    required List<Loan> loans,
    required List<EMI> emis,
    required List<LoanDocument> documents,
  }) async {
    _lender = lender;
    _customers
      ..clear()
      ..addAll(customers);
    _loans
      ..clear()
      ..addAll(loans);
    _emis
      ..clear()
      ..addAll(emis);
    _documents
      ..clear()
      ..addAll(documents);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> updateCustomer(Customer customer) async {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String id) async {
    _customers.removeWhere((c) => c.id == id);
    _loans.removeWhere((l) => l.customerId == id);
    _emis.removeWhere((e) => _loans.any((l) => l.id == e.loanId && l.customerId == id));
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> addLoan(Loan loan) async {
    _loans.add(loan);
    await _generateEMIs(loan);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _generateEMIs(Loan loan) async {
    final emiAmount = loan.monthlyEMI;
    final startDate = loan.startDate;

    for (int i = 1; i <= loan.tenureMonths; i++) {
      final dueDate = DateTime(startDate.year, startDate.month + i, startDate.day);
      _emis.add(EMI(
        loanId: loan.id,
        installmentNumber: i,
        amount: double.parse(emiAmount.toStringAsFixed(2)),
        dueDate: dueDate,
      ));
    }
  }

  Future<void> updateLoan(Loan loan) async {
    final index = _loans.indexWhere((l) => l.id == loan.id);
    if (index != -1) {
      _loans[index] = loan;
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> deleteLoan(String id) async {
    _loans.removeWhere((l) => l.id == id);
    _emis.removeWhere((e) => e.loanId == id);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> payEMI(String emiId, {String? paymentMethod}) async {
    final index = _emis.indexWhere((e) => e.id == emiId);
    if (index != -1) {
      _emis[index] = _emis[index].copyWith(
        status: EMIStatus.paid,
        paidDate: DateTime.now(),
        paymentMethod: paymentMethod ?? 'Cash',
        transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      );
      await _checkLoanCompletion(_emis[index].loanId);
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> payAllEMIs(String loanId, {String? paymentMethod}) async {
    final loanEMIs = _emis.where((e) => e.loanId == loanId && e.status == EMIStatus.pending).toList();
    for (final emi in loanEMIs) {
      final index = _emis.indexWhere((e) => e.id == emi.id);
      if (index != -1) {
        _emis[index] = _emis[index].copyWith(
          status: EMIStatus.paid,
          paidDate: DateTime.now(),
          paymentMethod: paymentMethod ?? 'Cash',
          transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}${emi.installmentNumber}',
        );
      }
    }
    await _checkLoanCompletion(loanId);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _checkLoanCompletion(String loanId) async {
    final loanEMIs = _emis.where((e) => e.loanId == loanId).toList();
    final allPaid = loanEMIs.every((e) => e.status == EMIStatus.paid);
    
    if (allPaid) {
      final loanIndex = _loans.indexWhere((l) => l.id == loanId);
      if (loanIndex != -1) {
        _loans[loanIndex] = _loans[loanIndex].copyWith(status: 'completed');
        await _generateLoanDocument(_loans[loanIndex]);
      }
    }
  }

  Future<void> _generateLoanDocument(Loan loan) async {
    final customer = getCustomerById(loan.customerId);
    if (customer == null || _lender == null) return;

    final loanEMIs = getEMIsByLoan(loan.id);
    final paidEMIs = loanEMIs.where((e) => e.status == EMIStatus.paid).toList();
    
    final fileName = 'Loan_Agreement_${customer.name}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
    
    final document = LoanDocument(
      loanId: loan.id,
      customerId: customer.id,
      fileName: fileName,
      filePath: '', // Will be set when PDF is actually generated
      generatedAt: DateTime.now(),
      totalAmount: loan.totalAmount,
      totalEMIs: loan.tenureMonths,
      paidEMIs: paidEMIs.length,
    );

    _documents.add(document);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> addDocument(LoanDocument document) async {
    final index = _documents.indexWhere((existing) => existing.id == document.id);
    if (index == -1) {
      _documents.add(document);
    } else {
      _documents[index] = document;
    }
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> deleteDocument(String id) async {
    _documents.removeWhere((d) => d.id == id);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final data = {
      'lender': _lender?.toJson(),
      'customers': _customers.map((c) => c.toJson()).toList(),
      'loans': _loans.map((l) => l.toJson()).toList(),
      'emis': _emis.map((e) => e.toJson()).toList(),
      'documents': _documents.map((d) => d.toJson()).toList(),
    };
    await database.writeState(data);
  }

  Future<void> saveToStorage() async {
    await _saveToStorage();
  }

  Future<void> reloadFromStorage() async {
    _lender = null;
    _customers.clear();
    _loans.clear();
    _emis.clear();
    _documents.clear();
    await _loadFromStorage();
    notifyListeners();
  }

  Future<void> _loadFromStorage() async {
    var data = await database.readState();
    if (data == null) {
      final prefs = await SharedPreferences.getInstance();
      final legacyData = prefs.getString('app_data');
      if (legacyData == null) return;
      data = Map<String, dynamic>.from(jsonDecode(legacyData) as Map);
      await database.writeState(data);
    }

    if (data['lender'] != null) {
      _lender = Lender.fromJson(
        Map<String, dynamic>.from(data['lender'] as Map),
      );
    }
    _customers.addAll(
      (data['customers'] as List? ?? []).map(
        (e) => Customer.fromJson(Map<String, dynamic>.from(e as Map)),
      ),
    );
    _loans.addAll(
      (data['loans'] as List? ?? []).map(
        (e) => Loan.fromJson(Map<String, dynamic>.from(e as Map)),
      ),
    );
    _emis.addAll(
      (data['emis'] as List? ?? []).map(
        (e) => EMI.fromJson(Map<String, dynamic>.from(e as Map)),
      ),
    );
    _documents.addAll(
      (data['documents'] as List? ?? []).map(
        (e) => LoanDocument.fromJson(Map<String, dynamic>.from(e as Map)),
      ),
    );
  }

  void clearAllData() {
    _lender = null;
    _customers.clear();
    _loans.clear();
    _emis.clear();
    _documents.clear();
    _saveToStorage();
    notifyListeners();
  }
}