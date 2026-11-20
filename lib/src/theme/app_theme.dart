// Kayko theme. Colours come from AppTokens (sampled from the product
// screenshots); the Material ColorScheme is filled from the same values so
// stock Material widgets match the Kayko components.
//
// Built with fromSeed(...).copyWith(...) instead of the ColorScheme(...)
// constructor: in Flutter 3.50 the optional colours are private named
// parameters, which packages on a language version below 3.12 can't pass.
//
// Font: the screenshots use Inter. Add the Inter font files to app_ui's
// pubspec (fonts: - family: Inter). Until then Flutter falls back to the
// platform font.
import 'package:flutter/material.dart';

import 'app_tokens.dart';

abstract final class AppTheme {
  static ThemeData light({AppTokens tokens = AppTokens.light}) {
    final scheme = ColorScheme.fromSeed(seedColor: tokens.primary).copyWith(
      primary: tokens.primary,
      onPrimary: tokens.onPrimary,
      primaryContainer: tokens.primarySubtle,
      onPrimaryContainer: tokens.primaryTextStrong,
      secondary: tokens.primary,
      onSecondary: tokens.onPrimary,
      error: tokens.danger,
      onError: tokens.onPrimary,
      surface: tokens.surface,
      onSurface: tokens.textStrong,
      onSurfaceVariant: tokens.textMuted,
      outline: tokens.borderStrong,
      outlineVariant: tokens.border,
    );
    return ThemeData(
      colorScheme: scheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: tokens.surface,
      dividerColor: tokens.borderSubtle,
      extensions: [tokens],
    );
  }
}
