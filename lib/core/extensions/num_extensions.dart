import 'package:loan_management_app/core/utils/currency_formatter.dart';

extension PaiseX on int {
  /// This amount in paise as `1,23,456.00`.
  String toRupeeString({String symbol = ''}) {
    return CurrencyFormatter.format(this, symbol: symbol);
  }
}

extension RateX on double {
  /// A rate for display: `12` for 12.0, `10.5` for 10.5.
  String get rateText => this == roundToDouble() ? toStringAsFixed(0) : '$this';
}
