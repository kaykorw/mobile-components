// AppVerificationCodeInput: Flutter counterpart of React <VerificationCodeInput>.
//
// One hidden TextField captures the whole code (so typing, Backspace, paste and
// SMS autofill all work natively); the boxes just display it.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundation/app_form_field.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// Same names as React `CodeInputType`.
enum AppVerificationCodeInputType { numeric, alphanumeric }

class AppVerificationCodeInput extends StatefulWidget {
  const AppVerificationCodeInput({
    super.key,
    this.length = 6,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onCompleted,
    this.type = AppVerificationCodeInputType.numeric,
    this.isMasked = false,
    this.label,
    this.errorText,
    this.isDisabled = false,
    this.autofocus = false,
    this.size = AppFieldSize.medium,
    this.isCentered = true,
    this.focusNode,
  });

  /// Number of boxes.
  final int length;
  final TextEditingController? controller;
  final String? initialValue;

  /// Called on every change with the code typed so far.
  final ValueChanged<String>? onChanged;

  /// Called once all boxes are filled.
  final ValueChanged<String>? onCompleted;

  /// numeric shows the number keypad and ignores letters.
  final AppVerificationCodeInputType type;

  /// Show dots instead of the characters.
  final bool isMasked;

  /// Label above the boxes, e.g. "VERIFICATION CODE".
  final String? label;

  /// Error message under the boxes. Turns the borders red.
  final String? errorText;
  final bool isDisabled;
  final bool autofocus;

  /// Box height: 40 / 48 / 56 px.
  final AppFieldSize size;

  /// Centre the label and boxes (as on the verify card) or align them left.
  final bool isCentered;
  final FocusNode? focusNode;

  @override
  State<AppVerificationCodeInput> createState() => _AppVerificationCodeInputState();
}

class _AppVerificationCodeInputState extends State<AppVerificationCodeInput> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;
  bool _focused = false;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController(text: widget.initialValue));
  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocus);
    _controller.addListener(_onText);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);
    _controller.removeListener(_onText);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _onFocus() => setState(() => _focused = _focusNode.hasFocus);
  void _onText() => setState(() {});

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  (double, double, double) get _boxSize => switch (widget.size) {
        AppFieldSize.small => (36.0, 40.0, AppType.lg),
        AppFieldSize.medium => (44.0, 48.0, 20.0),
        AppFieldSize.large => (52.0, 56.0, AppType.x2l),
      };

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final code = _controller.text;
    final (boxWidth, boxHeight, fontSize) = _boxSize;
    final hasError = widget.errorText != null;
    final activeIndex = code.length.clamp(0, widget.length - 1);

    final boxes = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s2),
          _box(
            t,
            char: i < code.length ? (widget.isMasked ? '•' : code[i]) : '',
            active: _focused && i == activeIndex,
            filled: i < code.length,
            hasError: hasError,
            width: boxWidth,
            height: boxHeight,
            fontSize: fontSize,
          ),
        ],
      ],
    );

    final isNumeric = widget.type == AppVerificationCodeInputType.numeric;
    final hiddenField = Opacity(
      opacity: 0,
      alwaysIncludeSemantics: true,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: !widget.isDisabled,
        autofocus: widget.autofocus,
        showCursor: false,
        enableInteractiveSelection: true,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.visiblePassword,
        textCapitalization: TextCapitalization.characters,
        autofillHints: const [AutofillHints.oneTimeCode],
        inputFormatters: [
          FilteringTextInputFormatter.allow(isNumeric ? RegExp('[0-9]') : RegExp('[0-9a-zA-Z]')),
          LengthLimitingTextInputFormatter(widget.length),
          if (!isNumeric) _UpperCaseFormatter(),
        ],
        onChanged: _handleChanged,
        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
        decoration: const InputDecoration.collapsed(hintText: null),
      ),
    );

    final field = Semantics(
      label: widget.label ?? 'Verification code',
      child: SizedBox(
        height: boxHeight,
        child: Stack(
          children: [
            IgnorePointer(child: boxes),
            Positioned.fill(child: hiddenField),
          ],
        ),
      ),
    );

    final alignment = widget.isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        if (widget.label case final text?) ...[
          ExcludeSemantics(
            child: Text(
              text.toUpperCase(),
              style: AppType.style(AppType.sm, weight: FontWeight.w600, color: t.text, letterSpacing: 0.8),
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
        ],
        field,
        if (widget.errorText case final text?) ...[
          const SizedBox(height: AppSpacing.s3),
          Text(text, style: AppType.style(AppType.sm, color: t.dangerText)),
        ],
      ],
    );
  }

  Widget _box(
    AppTokens t, {
    required String char,
    required bool active,
    required bool filled,
    required bool hasError,
    required double width,
    required double height,
    required double fontSize,
  }) {
    Color border = filled ? t.borderStrong : t.border;
    List<BoxShadow>? shadow;
    if (hasError) {
      border = t.dangerAccent;
      if (active) shadow = [BoxShadow(color: t.dangerSubtle, spreadRadius: 4)];
    } else if (active) {
      border = t.primaryBorder;
      shadow = [BoxShadow(color: t.focusRing, spreadRadius: 4)];
    }
    return AnimatedContainer(
      duration: AppDurations.fast,
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.isDisabled ? t.surfaceMuted : t.surface,
        borderRadius: AppRadius.all(AppRadius.lg),
        border: Border.all(color: border),
        boxShadow: shadow,
      ),
      child: Text(
        char,
        style: AppType.style(
          fontSize,
          weight: FontWeight.w600,
          color: widget.isDisabled ? t.textDisabled : t.textStrong,
        ),
      ),
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) =>
      newValue.copyWith(text: newValue.text.toUpperCase());
}
