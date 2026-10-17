import 'package:flutter/material.dart';

/// Material 3 colour schemes generated from one seed colour.
abstract final class AppColors {
  /// Seed colour for both themes.
  static const Color seed = Color(0xFF0F6E7A);

  static final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: seed,
  );

  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );
}
