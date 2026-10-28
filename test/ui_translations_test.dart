import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/l10n/ui_translations.dart';
import 'package:loan_management_app/providers/app_locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'translates interpolated messages for all supported languages',
    () async {
      await UiTranslations.load();

      for (final languageCode in AppLocaleProvider.supportedLanguageCodes) {
        final translated = UiTranslations.translate(
          languageCode,
          'Pay EMI #17?',
        );

        expect(translated, contains('17'), reason: languageCode);
        if (languageCode != 'en') {
          expect(translated, isNot('Pay EMI #17?'), reason: languageCode);
        }
      }
    },
  );

  test('provides precise Hindi translations for PDF labels', () async {
    await UiTranslations.load();

    expect(
      UiTranslations.translateKey('hi', 'emiScheduleTitle'),
      'ईएमआई भुगतान अनुसूची',
    );
    expect(
      UiTranslations.translateKey('hi', 'installmentHeader'),
      'किस्त क्रमांक',
    );
    expect(
      UiTranslations.translateKey('hi', 'loanStatusLabel'),
      'ऋण की स्थिति',
    );
    expect(
      UiTranslations.translateKey('hi', 'principalAmountLabel'),
      'मूल ऋण राशि',
    );
    expect(
      UiTranslations.translateKey('hi', 'partiesTitle'),
      'समझौते के पक्षकार',
    );
  });
}
