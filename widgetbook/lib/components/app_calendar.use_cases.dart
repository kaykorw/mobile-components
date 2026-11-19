// Use-case names (Single, Range, Restricted) MUST match the React story names.
// Never rename them once embedded in zeroheight.
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'preview_surface.dart';

// Dates relative to today, so every use case opens on the current month.
DateTime _inDays(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days);
}

bool _isWeekend(DateTime date) =>
    date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

AppCalendarWeekStart _weekStartKnob(BuildContext context) => context.knobs.object.dropdown(
      label: 'weekStartsOn',
      options: AppCalendarWeekStart.values,
      initialOption: AppCalendarWeekStart.monday,
      labelBuilder: (value) => value.name,
    );

@widgetbook.UseCase(name: 'Single', type: AppCalendar, path: '[Components]/inputs')
Widget buildAppCalendarSingle(BuildContext context) => previewSurface(
      context,
      AppCalendar.single(
        selectedDate: _inDays(0),
        weekStartsOn: _weekStartKnob(context),
        onChanged: (_) {},
      ),
    );

@widgetbook.UseCase(name: 'Range', type: AppCalendar, path: '[Components]/inputs')
Widget buildAppCalendarRange(BuildContext context) => previewSurface(
      context,
      AppCalendar.range(
        selectedRange: AppDateRange(start: _inDays(2), end: _inDays(6)),
        weekStartsOn: _weekStartKnob(context),
        onChanged: (_) {},
      ),
    );

/// Only the next 60 days, weekdays only.
@widgetbook.UseCase(name: 'Restricted', type: AppCalendar, path: '[Components]/inputs')
Widget buildAppCalendarRestricted(BuildContext context) => previewSurface(
      context,
      AppCalendar.single(
        minDate: _inDays(0),
        maxDate: _inDays(60),
        isDateDisabled: _isWeekend,
        weekStartsOn: _weekStartKnob(context),
        onChanged: (_) {},
      ),
    );
