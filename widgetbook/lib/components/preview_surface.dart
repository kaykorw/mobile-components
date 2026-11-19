import 'package:flutter/material.dart';

/// Puts a use case on the theme's surface colour, so components are readable
/// in both Light and Dark whatever Widgetbook paints behind them.
Widget previewSurface(BuildContext context, Widget child) {
  return ColoredBox(
    color: Theme.of(context).colorScheme.surface,
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
}
