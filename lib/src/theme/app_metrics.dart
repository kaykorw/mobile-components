// Kayko radius, spacing, elevation and type scale.
// Same values as the --kayko-radius-*, --kayko-space-*, --kayko-shadow-* and
// --kayko-font-size-* tokens in react/src/styles/tokens.css.
import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double xs = 4; // badges, calendar days
  static const double sm = 6; // small buttons, pagination
  static const double md = 8; // buttons, inputs, menu items, icon tiles
  static const double lg = 12; // popovers, tables, code inputs
  static const double xl = 16; // cards, dialogs
  static const double full = 9999;

  static BorderRadius all(double radius) => BorderRadius.all(Radius.circular(radius));
}

abstract final class AppSpacing {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;
}

abstract final class AppShadows {
  static const List<BoxShadow> none = [];
  static const List<BoxShadow> xs = [
    BoxShadow(color: Color(0x0A101828), offset: Offset(0, 1), blurRadius: 2),
  ];
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x14101828), offset: Offset(0, 1), blurRadius: 3),
    BoxShadow(color: Color(0x0A101828), offset: Offset(0, 1), blurRadius: 2),
  ];
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1F101828), offset: Offset(0, 12), blurRadius: 24, spreadRadius: -6),
    BoxShadow(color: Color(0x0D101828), offset: Offset(0, 4), blurRadius: 8, spreadRadius: -2),
  ];
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x2E101828), offset: Offset(0, 24), blurRadius: 48, spreadRadius: -12),
  ];
}

/// Font sizes and weights. Colours come from [AppTokens].
abstract final class AppType {
  static const double xs = 12;
  static const double sm = 13;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 18;
  static const double x2l = 24; // page title
  static const double x3l = 28; // stat values, auth titles

  static TextStyle style(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 200);
}
