/// Reasons a form field can be invalid. The UI maps these to localized text.
enum ValidationError {
  nameRequired,
  mobileInvalid,
  amountInvalid,
  rateInvalid,
  tenureInvalid,
  mpinInvalid,
}

/// Pure field validators. Each returns `null` when the value is valid.
abstract final class Validators {
  /// Indian mobile: 10 digits starting with 6, 7, 8 or 9.
  static final RegExp _mobile = RegExp(r'^[6-9]\d{9}$');

  static final RegExp _mpin = RegExp(r'^(\d{4}|\d{6})$');

  static ValidationError? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationError.nameRequired;
    }
    return null;
  }

  static ValidationError? mobile(String? value) {
    if (value == null || !_mobile.hasMatch(value.trim())) {
      return ValidationError.mobileInvalid;
    }
    return null;
  }

  /// Amount in paise; must be greater than zero.
  static ValidationError? amountPaise(int? value) {
    if (value == null || value <= 0) {
      return ValidationError.amountInvalid;
    }
    return null;
  }

  /// Annual interest rate in percent, 0 to 100 inclusive.
  static ValidationError? ratePercent(double? value) {
    if (value == null || value.isNaN || value < 0 || value > 100) {
      return ValidationError.rateInvalid;
    }
    return null;
  }

  /// Tenure in months, 1 to 600 inclusive.
  static ValidationError? tenureMonths(int? value) {
    if (value == null || value < 1 || value > 600) {
      return ValidationError.tenureInvalid;
    }
    return null;
  }

  /// MPIN: exactly 4 or exactly 6 digits.
  static ValidationError? mpin(String? value) {
    if (value == null || !_mpin.hasMatch(value)) {
      return ValidationError.mpinInvalid;
    }
    return null;
  }
}
