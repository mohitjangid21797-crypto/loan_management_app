import 'package:flutter/material.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/currency_formatter.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/l10n/generated/app_localizations.dart';

extension ContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textStyles => theme.textTheme;

  /// An amount in paise as `₹1,23,456.00`.
  String money(int paise) {
    return CurrencyFormatter.format(paise, symbol: AppConstants.currencySymbol);
  }

  /// A date in the current language, for example `17 Oct 2026`.
  String formatDate(DateTime date) {
    return AppDateUtils.formatDisplay(
      date,
      Localizations.localeOf(this).toString(),
    );
  }

  /// Shows a single snackbar, replacing any that is visible.
  void showSnack(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

extension ValidationErrorL10n on ValidationError {
  String message(AppLocalizations l10n) {
    return switch (this) {
      ValidationError.nameRequired => l10n.validationNameRequired,
      ValidationError.mobileInvalid => l10n.validationMobileInvalid,
      ValidationError.amountInvalid => l10n.validationAmountInvalid,
      ValidationError.rateInvalid => l10n.validationRateInvalid,
      ValidationError.tenureInvalid => l10n.validationTenureInvalid,
      ValidationError.mpinInvalid => l10n.validationMpinInvalid,
    };
  }
}

extension FailureL10n on Failure {
  String message(AppLocalizations l10n) {
    return switch (this) {
      NetworkFailure() => l10n.errorNetwork,
      DatabaseFailure() => l10n.errorDatabase,
      NotFoundFailure() => l10n.errorNotFound,
      DuplicateMobileFailure() => l10n.errorDuplicateMobile,
      ActiveLoanFailure() => l10n.errorActiveLoan,
      OutOfOrderPaymentFailure() => l10n.errorOutOfOrder,
      AlreadyPaidFailure() => l10n.errorAlreadyPaid,
      LoanNotPaidFailure() => l10n.errorLoanNotPaid,
      ValidationFailure(:final error) => error.message(l10n),
      _ => l10n.errorGeneric,
    };
  }
}
