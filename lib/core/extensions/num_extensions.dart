import 'package:loan_management_app/core/utils/currency_formatter.dart';

extension PaiseX on int {
  /// This amount in paise as `1,23,456.00`.
  String toRupeeString({String symbol = ''}) {
    return CurrencyFormatter.format(this, symbol: symbol);
  }
}
