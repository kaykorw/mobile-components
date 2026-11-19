// AppCheckbox: Flutter counterpart of React <Checkbox>.
//
// API mapping (React -> Flutter):
//   checked        -> value
//   indeterminate  -> isIndeterminate
//   disabled       -> isDisabled
//   error          -> errorText
//   label, description: same names
//   onChange(event) -> onChanged(bool)
//
// Clicking an indeterminate checkbox checks it, on both platforms.
import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.errorText,
    this.isIndeterminate = false,
    this.isDisabled = false,
  });

  /// Checked or not. Ignored for display while [isIndeterminate] is true.
  final bool value;

  /// Called with the new value. Tapping the label also toggles the checkbox.
  final ValueChanged<bool>? onChanged;

  /// Text next to the box.
  final String? label;

  /// Helper text under the label.
  final String? description;

  /// Error message under the label. Turns the box red.
  final String? errorText;

  /// Shows a dash: some, but not all, children are selected.
  final bool isIndeterminate;

  /// Blocks interaction and greys the checkbox out.
  final bool isDisabled;

  bool get _isEnabled => !isDisabled && onChanged != null;

  void _toggle() => onChanged?.call(isIndeterminate ? true : !value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final hasError = errorText != null;
    final disabledColor = colors.onSurface.withValues(alpha: 0.38);

    // 24 x 24 like React: shrinkWrap (40) + minimum density (-16).
    final box = Checkbox(
      value: isIndeterminate ? null : value,
      tristate: true,
      isError: hasError,
      onChanged: _isEnabled ? (_) => _toggle() : null,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      splashRadius: 14,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      // Fill and check colours use the Material 3 defaults (primary / error /
      // 38% when disabled). Only the unchecked border is customised.
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const BorderSide(width: 0, color: Colors.transparent);
        }
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(width: 2, color: disabledColor);
        }
        if (states.contains(WidgetState.error)) {
          return BorderSide(width: 2, color: colors.error);
        }
        return BorderSide(width: 2, color: colors.outline);
      }),
    );

    final hasText = label != null || description != null || hasError;
    if (!hasText) {
      return Material(type: MaterialType.transparency, child: box);
    }

    final textStyle = theme.textTheme.bodyMedium ?? const TextStyle();
    final labelStyle = textStyle.copyWith(
      fontSize: 14,
      height: 24 / 14,
      color: _isEnabled ? colors.onSurface : disabledColor,
    );
    final helperStyle = textStyle.copyWith(fontSize: 13, height: 18 / 13);

    return Material(
      type: MaterialType.transparency,
      child: MergeSemantics(
        child: MouseRegion(
          cursor: _isEnabled ? SystemMouseCursors.click : MouseCursor.defer,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isEnabled ? _toggle : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                box,
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label case final label?) Text(label, style: labelStyle),
                      if (description case final description?)
                        Text(
                          description,
                          style: helperStyle.copyWith(
                            color: _isEnabled ? colors.onSurfaceVariant : disabledColor,
                          ),
                        ),
                      if (errorText case final errorText?)
                        Text(errorText, style: helperStyle.copyWith(color: colors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
