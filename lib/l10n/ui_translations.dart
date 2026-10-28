import 'dart:convert';

import 'package:flutter/services.dart';

class UiTranslations {
  UiTranslations._();

  static final Map<String, Map<String, String>> _translations = {};
  static final Map<String, Map<String, String>> _keyedTranslations = {};
  static final Map<String, List<_TranslationPattern>> _patterns = {};

  static Future<void> load() async {
    final english = await _loadCatalog('en');
    for (final languageCode in [
      'as',
      'bn',
      'gu',
      'hi',
      'kn',
      'ml',
      'mr',
      'ne',
      'or',
      'pa',
      'ta',
      'te',
      'ur',
    ]) {
      final catalog = await _loadCatalog(languageCode);
      final translatedMessages = <String, String>{};
      final keyedTranslations = <String, String>{};
      final patterns = <_TranslationPattern>[];

      for (final entry in english.entries) {
        if (entry.key.startsWith('@') || entry.value is! String) continue;
        final translatedValue = catalog[entry.key];
        if (translatedValue is! String) {
          throw FormatException(
            'Missing "$languageCode" translation for "${entry.key}"',
          );
        }

        final source = entry.value as String;
        translatedMessages[source] = translatedValue;
        keyedTranslations[entry.key] = translatedValue;
        if (source.contains('{')) {
          patterns.add(_TranslationPattern(source, translatedValue));
        }
      }

      _translations[languageCode] = translatedMessages;
      _keyedTranslations[languageCode] = keyedTranslations;
      _patterns[languageCode] = patterns;
    }

    final englishMessages = <String, String>{};
    final englishKeyedMessages = <String, String>{};
    for (final entry in english.entries) {
      if (entry.value is! String || entry.key.startsWith('@')) continue;
      englishMessages[entry.value as String] = entry.value as String;
      englishKeyedMessages[entry.key] = entry.value as String;
    }
    _translations['en'] = englishMessages;
    _keyedTranslations['en'] = englishKeyedMessages;
  }

  static Future<Map<String, dynamic>> _loadCatalog(String languageCode) async {
    final source = await rootBundle.loadString(
      'lib/l10n/app_$languageCode.arb',
    );
    return jsonDecode(source) as Map<String, dynamic>;
  }

  static String translate(String languageCode, String source) {
    final catalog = _translations[languageCode];
    if (catalog == null) return source;

    final exact = catalog[source];
    if (exact != null) return exact;

    for (final pattern in _patterns[languageCode] ?? const []) {
      final match = pattern.expression.firstMatch(source);
      if (match == null) continue;

      final capturedValues = <String, String>{};
      var groupIndex = 0;
      for (final placeholder in RegExp(
        r'\{([^}]+)\}',
      ).allMatches(pattern.source)) {
        capturedValues[placeholder.group(1)!] = match.group(++groupIndex) ?? '';
      }

      final output = StringBuffer();
      var position = 0;
      for (final placeholder in RegExp(
        r'\{([^}]+)\}',
      ).allMatches(pattern.translated)) {
        output.write(pattern.translated.substring(position, placeholder.start));
        output.write(capturedValues[placeholder.group(1)] ?? '');
        position = placeholder.end;
      }
      output.write(pattern.translated.substring(position));
      return output.toString();
    }

    return source;
  }

  static String translateKey(String languageCode, String key) {
    final translation = _keyedTranslations[languageCode]?[key];
    if (translation == null) {
      throw StateError('Missing "$languageCode" translation for "$key"');
    }
    return translation;
  }
}

class _TranslationPattern {
  final String source;
  final String translated;
  final RegExp expression;

  _TranslationPattern(this.source, this.translated)
    : expression = _buildExpression(source);

  static RegExp _buildExpression(String source) {
    final expression = StringBuffer('^');
    final placeholders = RegExp(r'\{[^}]+\}');
    var position = 0;

    for (final match in placeholders.allMatches(source)) {
      expression.write(RegExp.escape(source.substring(position, match.start)));
      expression.write('(.+?)');
      position = match.end;
    }

    expression
      ..write(RegExp.escape(source.substring(position)))
      ..write(r'$');
    return RegExp(expression.toString(), dotAll: true);
  }
}
