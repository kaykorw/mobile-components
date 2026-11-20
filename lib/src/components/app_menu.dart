// AppMenu and AppMenuItem: Flutter counterparts of React <Menu> and <MenuItem>.
// Rows in a list of choices: date presets, filter categories, action menus,
// select options, sidebar links.
import 'package:flutter/material.dart';

import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

/// Same names as React `trailing`.
enum AppMenuItemTrailing { none, chevron, check }

class AppMenuItem extends StatelessWidget {
  const AppMenuItem({
    super.key,
    required this.label,
    this.onTap,
    this.isSelected = false,
    this.leading,
    this.trailing = AppMenuItemTrailing.none,
    this.trailingWidget,
    this.description,
    this.isDanger = false,
    this.isDisabled = false,
    this.autofocus = false,
  });

  /// Item text, e.g. "Status" or "Last 7 days".
  final String label;
  final VoidCallback? onTap;

  /// Highlighted as the current choice (light blue).
  final bool isSelected;

  /// Icon before the label.
  final Widget? leading;

  /// chevron: opens more (Filters categories). check: shows a check when selected (presets).
  final AppMenuItemTrailing trailing;

  /// Custom widget at the end (instead of [trailing]).
  final Widget? trailingWidget;

  /// Smaller second line under the label.
  final String? description;

  /// Red text for destructive actions.
  final bool isDanger;
  final bool isDisabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return AppPressable(
      onTap: onTap,
      enabled: !isDisabled,
      selected: isSelected,
      autofocus: autofocus,
      semanticLabel: label,
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final focused = states.contains(WidgetState.focused);

        final Color background = isSelected
            ? t.primarySubtle
            : hovered
                ? t.surfaceMuted
                : Colors.transparent;
        final Color foreground = isDisabled
            ? t.textDisabled
            : isDanger
                ? t.dangerText
                : isSelected
                    ? t.primaryTextStrong
                    : t.textEmphasis;

        Widget? end = trailingWidget;
        if (end == null) {
          switch (trailing) {
            case AppMenuItemTrailing.chevron:
              end = AppIcon(AppIcons.chevronRight, size: 16, color: isSelected ? t.primaryText : t.borderStrong);
            case AppMenuItemTrailing.check:
              end = isSelected ? AppIcon(AppIcons.check, size: 16, color: t.primaryText) : null;
            case AppMenuItemTrailing.none:
              end = null;
          }
        }

        return AnimatedContainer(
          duration: AppDurations.fast,
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: background,
            borderRadius: AppRadius.all(AppRadius.md),
            border: focused ? Border.all(color: t.primaryBorder, width: 2) : null,
          ),
          child: Row(
            children: [
              if (leading case final icon?) ...[
                IconTheme.merge(
                  data: IconThemeData(color: isSelected ? t.primaryText : t.textMuted, size: 16),
                  child: icon,
                ),
                const SizedBox(width: AppSpacing.s3),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.style(AppType.md, color: foreground),
                    ),
                    if (description case final text?) ...[
                      const SizedBox(height: 2),
                      Text(text, style: AppType.style(AppType.sm, color: t.textMuted)),
                    ],
                  ],
                ),
              ),
              if (end != null) ...[const SizedBox(width: AppSpacing.s3), end],
            ],
          ),
        );
      },
    );
  }
}

/// Vertical list of [AppMenuItem]s. Arrow keys move between items.
class AppMenu extends StatelessWidget {
  const AppMenu({super.key, required this.children, this.semanticLabel, this.padding = const EdgeInsets.all(8)});

  final List<Widget> children;

  /// Accessible name of the list.
  final String? semanticLabel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: FocusTraversalGroup(
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: 2),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
