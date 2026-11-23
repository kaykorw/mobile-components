// Shared interaction layer for Kayko components: hover, press, keyboard focus
// (Tab + Enter/Space) and semantics, without Material ink. Components paint
// their own hover/pressed colours from the states, like the React CSS does.
//
// Only uses constructor parameters that are public in Flutter 3.50 (no
// private named parameters), so it analyzes on any app_ui language version.
import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

typedef AppStatesBuilder = Widget Function(BuildContext context, Set<WidgetState> states);

class AppPressable extends StatefulWidget {
  const AppPressable({
    super.key,
    required this.builder,
    this.onTap,
    this.enabled = true,
    this.focusable = true,
    this.isButton = true,
    this.selected,
    this.checked,
    this.mixed,
    this.inMutuallyExclusiveGroup = false,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.onHoverChanged,
    this.mouseCursor,
  });

  /// Builds the visuals from the current states: hovered, pressed, focused
  /// (keyboard only), disabled and selected.
  final AppStatesBuilder builder;

  /// Called on tap, Enter or Space. Null makes it non-interactive but still focusable when [enabled].
  final VoidCallback? onTap;

  /// False greys it out and removes it from the focus order.
  final bool enabled;

  /// False keeps it out of the Tab order (e.g. calendar days handled by a grid).
  final bool focusable;
  final bool isButton;
  final bool? selected;
  final bool? checked;

  /// Tri-state checkbox in the "indeterminate" state.
  final bool? mixed;
  final bool inMutuallyExclusiveGroup;

  /// Accessible name, for icon-only controls.
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<bool>? onHoverChanged;
  final MouseCursor? mouseCursor;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _interactive => widget.enabled && widget.onTap != null;

  void _activate() {
    if (_interactive) widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final states = <WidgetState>{
      if (!widget.enabled) WidgetState.disabled,
      if (_hovered && _interactive) WidgetState.hovered,
      if (_pressed && _interactive) WidgetState.pressed,
      if (_focused) WidgetState.focused,
      if (widget.selected ?? false) WidgetState.selected,
    };

    return Semantics(
      container: true,
      button: widget.isButton,
      enabled: widget.enabled,
      selected: widget.selected,
      checked: widget.checked,
      mixed: widget.mixed,
      inMutuallyExclusiveGroup: widget.inMutuallyExclusiveGroup ? true : null,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        enabled: widget.enabled && widget.focusable,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: widget.mouseCursor ??
            (_interactive ? SystemMouseCursors.click : SystemMouseCursors.basic),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        onShowHoverHighlight: (value) {
          setState(() => _hovered = value);
          widget.onHoverChanged?.call(value);
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            _activate();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _interactive ? _activate : null,
          onTapDown: _interactive ? (_) => setState(() => _pressed = true) : null,
          onTapUp: _interactive ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: _interactive ? () => setState(() => _pressed = false) : null,
          child: widget.builder(context, states),
        ),
      ),
    );
  }
}

/// Draws a 2 px focus ring 2 px outside [child] when [visible], like the
/// React `outline: 2px solid var(--kayko-color-primary-border); outline-offset: 2px`.
class AppFocusRing extends StatelessWidget {
  const AppFocusRing({
    super.key,
    required this.visible,
    required this.child,
    this.borderRadius = 8,
    this.color,
  });

  final bool visible;
  final Widget child;
  final double borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;
    final ringColor = color ?? AppTokens.of(context).primaryBorder;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          left: -4,
          top: -4,
          right: -4,
          bottom: -4,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: ringColor, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(borderRadius + 4)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
