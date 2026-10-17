import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter.format', () {
    test('uses Indian digit grouping', () {
      expect(CurrencyFormatter.format(12345600), '1,23,456.00');
      expect(CurrencyFormatter.format(100000000), '10,00,000.00');
      expect(CurrencyFormatter.format(99999), '999.99');
      expect(CurrencyFormatter.format(100000), '1,000.00');
    });

    test('handles zero, small and negative amounts', () {
      expect(CurrencyFormatter.format(0), '0.00');
      expect(CurrencyFormatter.format(5), '0.05');
      expect(CurrencyFormatter.format(-12345), '-123.45');
    });

    test('prefixes the symbol after the sign', () {
      expect(CurrencyFormatter.format(12345600, symbol: '₹'), '₹1,23,456.00');
      expect(CurrencyFormatter.format(-100, symbol: '₹'), '-₹1.00');
    });
  });

  group('CurrencyFormatter.tryParseToPaise', () {
    test('parses whole and decimal amounts without doubles', () {
      expect(CurrencyFormatter.tryParseToPaise('1234'), 123400);
      expect(CurrencyFormatter.tryParseToPaise('1234.5'), 123450);
      expect(CurrencyFormatter.tryParseToPaise('1,23,456.07'), 12345607);
      expect(CurrencyFormatter.tryParseToPaise(' 0.01 '), 1);
    });

    test('rejects invalid input', () {
      expect(CurrencyFormatter.tryParseToPaise(''), isNull);
      expect(CurrencyFormatter.tryParseToPaise('abc'), isNull);
      expect(CurrencyFormatter.tryParseToPaise('12.345'), isNull);
      expect(CurrencyFormatter.tryParseToPaise('-5'), isNull);
    });
  });
}
