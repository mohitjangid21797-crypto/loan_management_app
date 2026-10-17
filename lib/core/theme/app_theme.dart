import 'package:flutter/material.dart';
import 'package:loan_management_app/core/theme/app_colors.dart';
import 'package:loan_management_app/core/theme/app_text_styles.dart';

/// Light and dark Material 3 themes.
abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.lightScheme);

  static ThemeData get dark => _build(AppColors.darkScheme);

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    return base.copyWith(
      textTheme: AppTextStyles.apply(base.textTheme),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: const AppBarTheme(centerTitle: false),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
