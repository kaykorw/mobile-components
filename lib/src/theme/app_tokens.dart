// GENERATED from react/src/styles/tokens.css by gen_tokens.py. Do not edit by hand:
// change tokens.css and regenerate, so React and Flutter stay identical.
//
// Every colour was sampled from the Kayko product screenshots.
import 'package:flutter/material.dart';

/// Kayko colour tokens. Read them with `AppTokens.of(context)`.
///
/// Override for a whole app (or a subtree) with a ThemeData extension:
///   ThemeData(extensions: [AppTokens.light.copyWith(primary: ...)])
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.primary,
    required this.primaryHover,
    required this.primaryPressed,
    required this.primaryDisabled,
    required this.primaryText,
    required this.primaryTextStrong,
    required this.primarySubtle,
    required this.primaryFaint,
    required this.primaryBorder,
    required this.primaryBorderSubtle,
    required this.focusRing,
    required this.onPrimary,
    required this.textStrong,
    required this.textHeading,
    required this.textEmphasis,
    required this.text,
    required this.textMuted,
    required this.textSubtle,
    required this.textDisabled,
    required this.textFaint,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceSunken,
    required this.borderSubtle,
    required this.border,
    required this.borderInput,
    required this.borderStrong,
    required this.success,
    required this.successSubtle,
    required this.successStrong,
    required this.successText,
    required this.warning,
    required this.warningSubtle,
    required this.danger,
    required this.dangerText,
    required this.dangerAccent,
    required this.dangerSubtle,
    required this.overlay,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
  });

  final Color primary;
  final Color primaryHover;
  final Color primaryPressed;
  final Color primaryDisabled;
  final Color primaryText;
  final Color primaryTextStrong;
  final Color primarySubtle;
  final Color primaryFaint;
  final Color primaryBorder;
  final Color primaryBorderSubtle;
  final Color focusRing;
  final Color onPrimary;
  final Color textStrong;
  final Color textHeading;
  final Color textEmphasis;
  final Color text;
  final Color textMuted;
  final Color textSubtle;
  final Color textDisabled;
  final Color textFaint;
  final Color surface;
  final Color surfaceMuted;
  final Color surfaceSunken;
  final Color borderSubtle;
  final Color border;
  final Color borderInput;
  final Color borderStrong;
  final Color success;
  final Color successSubtle;
  final Color successStrong;
  final Color successText;
  final Color warning;
  final Color warningSubtle;
  final Color danger;
  final Color dangerText;
  final Color dangerAccent;
  final Color dangerSubtle;
  final Color overlay;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;

  static const AppTokens light = AppTokens(
    primary: Color(0xFF4A99E9),
    primaryHover: Color(0xFF428AD2),
    primaryPressed: Color(0xFF3671AF),
    primaryDisabled: Color(0xFF74B2DF),
    primaryText: Color(0xFF428AD2),
    primaryTextStrong: Color(0xFF3671AF),
    primarySubtle: Color(0xFFF1F8FE),
    primaryFaint: Color(0xFFF8FCFF),
    primaryBorder: Color(0xFF8DC5F3),
    primaryBorderSubtle: Color(0xFFB2D9F8),
    focusRing: Color(0xFFE6F2FD),
    onPrimary: Color(0xFFFFFFFF),
    textStrong: Color(0xFF030816),
    textHeading: Color(0xFF121826),
    textEmphasis: Color(0xFF212936),
    text: Color(0xFF394150),
    textMuted: Color(0xFF6C727F),
    textSubtle: Color(0xFF9DA3AE),
    textDisabled: Color(0xFFB6B9BF),
    textFaint: Color(0xFFD9DCE1),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF9FAFB),
    surfaceSunken: Color(0xFFF2F5F9),
    borderSubtle: Color(0xFFF3F4F6),
    border: Color(0xFFEFF2F6),
    borderInput: Color(0xFFE3E8EF),
    borderStrong: Color(0xFFD2D5DA),
    success: Color(0xFF33803F),
    successSubtle: Color(0xFFF2FDF5),
    successStrong: Color(0xFF43946C),
    successText: Color(0xFF347659),
    warning: Color(0xFF9C630F),
    warningSubtle: Color(0xFFFEFCEA),
    danger: Color(0xFFCA3A31),
    dangerText: Color(0xFFAA2E26),
    dangerAccent: Color(0xFFDD524C),
    dangerSubtle: Color(0xFFFEF3F2),
    overlay: Color(0x1A030816),
    chart1: Color(0xFF4A99E9),
    chart2: Color(0xFF43946C),
    chart3: Color(0xFFCA3A31),
    chart4: Color(0xFF9C630F),
    chart5: Color(0xFF6C727F),
  );

  /// The tokens of the nearest theme, or [light] when none is registered.
  static AppTokens of(BuildContext context) =>
      Theme.of(context).extension<AppTokens>() ?? light;

  @override
  AppTokens copyWith({
    Color? primary,
    Color? primaryHover,
    Color? primaryPressed,
    Color? primaryDisabled,
    Color? primaryText,
    Color? primaryTextStrong,
    Color? primarySubtle,
    Color? primaryFaint,
    Color? primaryBorder,
    Color? primaryBorderSubtle,
    Color? focusRing,
    Color? onPrimary,
    Color? textStrong,
    Color? textHeading,
    Color? textEmphasis,
    Color? text,
    Color? textMuted,
    Color? textSubtle,
    Color? textDisabled,
    Color? textFaint,
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceSunken,
    Color? borderSubtle,
    Color? border,
    Color? borderInput,
    Color? borderStrong,
    Color? success,
    Color? successSubtle,
    Color? successStrong,
    Color? successText,
    Color? warning,
    Color? warningSubtle,
    Color? danger,
    Color? dangerText,
    Color? dangerAccent,
    Color? dangerSubtle,
    Color? overlay,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
  }) {
    return AppTokens(
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryPressed: primaryPressed ?? this.primaryPressed,
      primaryDisabled: primaryDisabled ?? this.primaryDisabled,
      primaryText: primaryText ?? this.primaryText,
      primaryTextStrong: primaryTextStrong ?? this.primaryTextStrong,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      primaryFaint: primaryFaint ?? this.primaryFaint,
      primaryBorder: primaryBorder ?? this.primaryBorder,
      primaryBorderSubtle: primaryBorderSubtle ?? this.primaryBorderSubtle,
      focusRing: focusRing ?? this.focusRing,
      onPrimary: onPrimary ?? this.onPrimary,
      textStrong: textStrong ?? this.textStrong,
      textHeading: textHeading ?? this.textHeading,
      textEmphasis: textEmphasis ?? this.textEmphasis,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textSubtle: textSubtle ?? this.textSubtle,
      textDisabled: textDisabled ?? this.textDisabled,
      textFaint: textFaint ?? this.textFaint,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      border: border ?? this.border,
      borderInput: borderInput ?? this.borderInput,
      borderStrong: borderStrong ?? this.borderStrong,
      success: success ?? this.success,
      successSubtle: successSubtle ?? this.successSubtle,
      successStrong: successStrong ?? this.successStrong,
      successText: successText ?? this.successText,
      warning: warning ?? this.warning,
      warningSubtle: warningSubtle ?? this.warningSubtle,
      danger: danger ?? this.danger,
      dangerText: dangerText ?? this.dangerText,
      dangerAccent: dangerAccent ?? this.dangerAccent,
      dangerSubtle: dangerSubtle ?? this.dangerSubtle,
      overlay: overlay ?? this.overlay,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      primaryDisabled: Color.lerp(primaryDisabled, other.primaryDisabled, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      primaryTextStrong: Color.lerp(primaryTextStrong, other.primaryTextStrong, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      primaryFaint: Color.lerp(primaryFaint, other.primaryFaint, t)!,
      primaryBorder: Color.lerp(primaryBorder, other.primaryBorder, t)!,
      primaryBorderSubtle: Color.lerp(primaryBorderSubtle, other.primaryBorderSubtle, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      textHeading: Color.lerp(textHeading, other.textHeading, t)!,
      textEmphasis: Color.lerp(textEmphasis, other.textEmphasis, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderInput: Color.lerp(borderInput, other.borderInput, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSubtle: Color.lerp(successSubtle, other.successSubtle, t)!,
      successStrong: Color.lerp(successStrong, other.successStrong, t)!,
      successText: Color.lerp(successText, other.successText, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSubtle: Color.lerp(warningSubtle, other.warningSubtle, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerText: Color.lerp(dangerText, other.dangerText, t)!,
      dangerAccent: Color.lerp(dangerAccent, other.dangerAccent, t)!,
      dangerSubtle: Color.lerp(dangerSubtle, other.dangerSubtle, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      chart1: Color.lerp(chart1, other.chart1, t)!,
      chart2: Color.lerp(chart2, other.chart2, t)!,
      chart3: Color.lerp(chart3, other.chart3, t)!,
      chart4: Color.lerp(chart4, other.chart4, t)!,
      chart5: Color.lerp(chart5, other.chart5, t)!,
    );
  }

  /// Chart series colours, in order.
  List<Color> get chartSeries => [chart1, chart2, chart3, chart4, chart5];
}
