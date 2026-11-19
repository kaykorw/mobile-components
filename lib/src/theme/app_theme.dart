// Placeholder Kayko themes.
//
// Colour values mirror react/src/styles/tokens.css (same role names:
// primary, onPrimary, primaryContainer, error, surface, outline, ...), so
// Widgetbook and Storybook look the same until the real Figma tokens land.
// Replace the values, keep the roles.
//
// If app_ui already has its own theme, keep yours and delete this file: the
// components only read Theme.of(context).colorScheme.
//
// Built with fromSeed(...).copyWith(...) rather than the ColorScheme(...)
// constructor: since Dart 3.12 the SDK declares the optional colours as
// private named parameters, which packages on an older language version
// can't pass. copyWith works on any version and fills the remaining roles
// (tertiary, surfaceContainer, ...) from the seed.
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(_light);
  static ThemeData dark() => _build(_dark);

  static const Color _seed = Color(0xFF2563EB);

  static final ColorScheme _light = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFF2563EB),
    onPrimary: const Color(0xFFFFFFFF),
    primaryContainer: const Color(0xFFDBE5FF),
    onPrimaryContainer: const Color(0xFF0B2A6B),
    secondary: const Color(0xFF2563EB),
    onSecondary: const Color(0xFFFFFFFF),
    error: const Color(0xFFD92D20),
    onError: const Color(0xFFFFFFFF),
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF1A1C22),
    onSurfaceVariant: const Color(0xFF5B6170),
    outline: const Color(0xFF767C8A),
    outlineVariant: const Color(0xFFD9DCE3),
  );

  static final ColorScheme _dark = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.dark,
  ).copyWith(
    primary: const Color(0xFF9DB8FF),
    onPrimary: const Color(0xFF0B2A6B),
    primaryContainer: const Color(0xFF1E3F99),
    onPrimaryContainer: const Color(0xFFDBE5FF),
    secondary: const Color(0xFF9DB8FF),
    onSecondary: const Color(0xFF0B2A6B),
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
    surface: const Color(0xFF121318),
    onSurface: const Color(0xFFE3E4EA),
    onSurfaceVariant: const Color(0xFFA9AEBA),
    outline: const Color(0xFF8B909C),
    outlineVariant: const Color(0xFF3A3E48),
  );

  static ThemeData _build(ColorScheme scheme) => ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: scheme.surface,
      );
}