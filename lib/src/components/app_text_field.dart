// AppTextField and AppTextarea: Flutter counterparts of React <TextField> and <Textarea>.
//
// API mapping (React -> Flutter): required -> isRequired, error -> errorText,
// disabled -> isDisabled, leadingIcon/trailing/prefix/suffix -> leading/trailing/
// prefixText/suffixText, clearable -> isClearable, placeholder: same.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundation/app_form_field.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.semanticLabel,
    this.placeholder,
    this.description,
    this.errorText,
    this.isRequired = false,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
    this.leading,
    this.trailing,
    this.prefixText,
    this.suffixText,
    this.isClearable = false,
    this.size = AppFieldSize.medium,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.width,
  })  : minLines = null,
        maxLines = 1,
        showCount = false;

  /// Multi-line field. Same look as AppTextField; grows from [minLines] to [maxLines].
  const AppTextField.multiline({
    super.key,
    this.label,
    this.semanticLabel,
    this.placeholder,
    this.description,
    this.errorText,
    this.isRequired = false,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.focusNode,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.autofocus = false,
    this.maxLength,
    this.showCount = false,
    this.minLines = 4,
    this.maxLines = 8,
    this.width,
  })  : onSubmitted = null,
        onClear = null,
        leading = null,
        trailing = null,
        prefixText = null,
        suffixText = null,
        isClearable = false,
        size = AppFieldSize.medium,
        obscureText = false,
        keyboardType = TextInputType.multiline,
        textInputAction = TextInputAction.newline,
        inputFormatters = null,
        autofillHints = null;

  /// Label above the field, e.g. "Account name".
  final String? label;

  /// Accessible name when there's no visible [label] (e.g. a search box).
  final String? semanticLabel;
  final String? placeholder;
  final String? description;

  /// Error message. Turns the border red.
  final String? errorText;

  /// Shows a red asterisk after the label.
  final bool isRequired;
  final TextEditingController? controller;

  /// Starting text when no [controller] is given.
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Called after the clear button empties the field.
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  /// Icon at the start, e.g. `AppIcon(AppIcons.search)`.
  final Widget? leading;

  /// Icon or small button at the end.
  final Widget? trailing;

  /// Fixed text before the value, e.g. "RWF".
  final String? prefixText;

  /// Fixed text after the value, e.g. "%".
  final String? suffixText;

  /// Shows an × button while there's a value.
  final bool isClearable;
  final AppFieldSize size;
  final bool isDisabled;
  final bool isReadOnly;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final int? maxLength;

  /// Shows "12 / 200" next to the label (multiline only). Needs [maxLength].
  final bool showCount;
  final int? minLines;
  final int? maxLines;

  /// Fixed width. By default the field fills its parent's width.
  final double? width;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;
  bool _focused = false;
  bool _hovered = false;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController(text: widget.initialValue));
  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
    }
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?.removeListener(_onTextChange);
      _controller.addListener(_onTextChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() => _focused = _focusNode.hasFocus);

  // Rebuild for the clear button and the character count.
  void _onTextChange() => setState(() {});

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final multiline = (widget.maxLines ?? 2) > 1;
    final hasValue = _controller.text.isNotEmpty;
    final textStyle = AppType.style(
      widget.size.fontSize,
      color: widget.isDisabled ? t.textDisabled : t.textStrong,
      height: multiline ? 1.5 : null,
    );

    final field = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: !widget.isDisabled,
      readOnly: widget.isReadOnly,
      obscureText: widget.obscureText,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      maxLength: widget.maxLength,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: textStyle,
      cursorColor: t.primary,
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
      decoration: InputDecoration.collapsed(
        hintText: widget.placeholder,
        hintStyle: textStyle.copyWith(color: t.textSubtle),
      ),
    );

    Widget affix(String text) => Text(text, style: AppType.style(widget.size.fontSize, color: t.textMuted));

    final box = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.text,
      child: GestureDetector(
        // Tapping the padding or an icon focuses the field.
        onTap: widget.isDisabled ? null : () => _focusNode.requestFocus(),
        child: AppFieldBox(
          size: widget.size,
          focused: _focused,
          hovered: _hovered,
          hasError: widget.errorText != null,
          isDisabled: widget.isDisabled,
          multiline: multiline,
          child: Row(
            crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              if (widget.leading case final lead?) ...[lead, const SizedBox(width: AppSpacing.s2)],
              if (widget.prefixText case final text?) ...[affix(text), const SizedBox(width: AppSpacing.s2)],
              Expanded(child: field),
              if (widget.suffixText case final text?) ...[const SizedBox(width: AppSpacing.s2), affix(text)],
              if (widget.isClearable && hasValue && !widget.isDisabled) ...[
                const SizedBox(width: AppSpacing.s2),
                Semantics(
                  button: true,
                  label: 'Clear',
                  child: GestureDetector(
                    onTap: _clear,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AppIcon(AppIcons.close, size: 14, color: t.textSubtle),
                    ),
                  ),
                ),
              ],
              if (widget.trailing case final trail?) ...[const SizedBox(width: AppSpacing.s2), trail],
            ],
          ),
        ),
      ),
    );

    final maxLength = widget.maxLength;
    final result = AppFormField(
      label: widget.label,
      isRequired: widget.isRequired,
      description: widget.description,
      errorText: widget.errorText,
      labelAside: widget.showCount && maxLength != null ? Text('${_controller.text.length} / $maxLength') : null,
      child: widget.label == null && widget.semanticLabel != null
          ? Semantics(label: widget.semanticLabel, textField: true, child: box)
          : box,
    );
    return widget.width == null ? result : SizedBox(width: widget.width, child: result);
  }
}

/// Multi-line text input with the same styling as [AppTextField].
/// Flutter counterpart of React <Textarea>.
class AppTextarea extends StatelessWidget {
  const AppTextarea({
    super.key,
    this.label,
    this.semanticLabel,
    this.placeholder,
    this.description,
    this.errorText,
    this.isRequired = false,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.focusNode,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.maxLength,
    this.showCount = false,
    this.minLines = 4,
    this.maxLines = 8,
    this.width,
  });

  final String? label;
  final String? semanticLabel;
  final String? placeholder;
  final String? description;
  final String? errorText;
  final bool isRequired;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool isDisabled;
  final bool isReadOnly;
  final int? maxLength;

  /// Shows "12 / 200" next to the label. Needs [maxLength].
  final bool showCount;
  final int minLines;
  final int maxLines;
  final double? width;

  @override
  Widget build(BuildContext context) => AppTextField.multiline(
        label: label,
        semanticLabel: semanticLabel,
        placeholder: placeholder,
        description: description,
        errorText: errorText,
        isRequired: isRequired,
        controller: controller,
        initialValue: initialValue,
        onChanged: onChanged,
        focusNode: focusNode,
        isDisabled: isDisabled,
        isReadOnly: isReadOnly,
        maxLength: maxLength,
        showCount: showCount,
        minLines: minLines,
        maxLines: maxLines,
        width: width,
      );
}
