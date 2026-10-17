/// Converts between integer paise and display strings with Indian digit
/// grouping (for example 1,23,456.00). Money is never held as a double.
abstract final class CurrencyFormatter {
  static final RegExp _input = RegExp(r'^\d+(\.\d{1,2})?$');

  /// Formats [paise] as `1,23,456.00`, optionally prefixed with [symbol].
  static String format(int paise, {String symbol = ''}) {
    final negative = paise < 0;
    final absolute = paise.abs();
    final rupees = _group((absolute ~/ 100).toString());
    final fraction = (absolute % 100).toString().padLeft(2, '0');
    return '${negative ? '-' : ''}$symbol$rupees.$fraction';
  }

  /// Parses user input such as `1,234.5` into paise. Returns `null` for
  /// anything that is not a non-negative amount with at most 2 decimals.
  static int? tryParseToPaise(String input) {
    final cleaned = input.trim().replaceAll(',', '');
    if (!_input.hasMatch(cleaned)) {
      return null;
    }
    final parts = cleaned.split('.');
    final whole = int.parse(parts[0]);
    final fraction = parts.length == 2 ? parts[1].padRight(2, '0') : '00';
    return whole * 100 + int.parse(fraction);
  }

  static String _group(String digits) {
    if (digits.length <= 3) {
      return digits;
    }
    final lastThree = digits.substring(digits.length - 3);
    final rest = digits.substring(0, digits.length - 3);
    final grouped = rest.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+$)'),
      (match) => '${match[1]},',
    );
    return '$grouped,$lastThree';
  }
}
