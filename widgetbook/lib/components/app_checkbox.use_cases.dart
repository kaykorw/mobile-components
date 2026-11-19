// Use-case names (Default, Checked, Indeterminate, Disabled, Error) MUST match
// the React story names. Never rename them once embedded in zeroheight.
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'preview_surface.dart';

Widget _buildCheckbox(
  BuildContext context, {
  String label = 'Email me a receipt',
  String? description,
  String? errorText,
  bool checked = false,
  bool indeterminate = false,
  bool disabled = false,
}) {
  final descriptionKnob = context.knobs.string(label: 'description', initialValue: description ?? '');
  final errorKnob = context.knobs.string(label: 'error', initialValue: errorText ?? '');
  return previewSurface(
    context,
    _CheckboxPlayground(
      label: context.knobs.string(label: 'label', initialValue: label),
      description: descriptionKnob.isEmpty ? null : descriptionKnob,
      errorText: errorKnob.isEmpty ? null : errorKnob,
      value: context.knobs.boolean(label: 'checked', initialValue: checked),
      isIndeterminate: context.knobs.boolean(label: 'indeterminate', initialValue: indeterminate),
      isDisabled: context.knobs.boolean(label: 'disabled', initialValue: disabled),
    ),
  );
}

@widgetbook.UseCase(name: 'Default', type: AppCheckbox, path: '[Components]/inputs')
Widget buildAppCheckboxDefault(BuildContext context) =>
    _buildCheckbox(context, description: 'Sent to the address on your account.');

@widgetbook.UseCase(name: 'Checked', type: AppCheckbox, path: '[Components]/inputs')
Widget buildAppCheckboxChecked(BuildContext context) => _buildCheckbox(context, checked: true);

@widgetbook.UseCase(name: 'Indeterminate', type: AppCheckbox, path: '[Components]/inputs')
Widget buildAppCheckboxIndeterminate(BuildContext context) =>
    _buildCheckbox(context, label: 'Select all products', indeterminate: true);

@widgetbook.UseCase(name: 'Disabled', type: AppCheckbox, path: '[Components]/inputs')
Widget buildAppCheckboxDisabled(BuildContext context) =>
    _buildCheckbox(context, checked: true, disabled: true);

@widgetbook.UseCase(name: 'Error', type: AppCheckbox, path: '[Components]/inputs')
Widget buildAppCheckboxError(BuildContext context) => _buildCheckbox(
      context,
      label: 'I accept the terms',
      errorText: 'Accept the terms to continue.',
    );

/// Lets the checkbox toggle when clicked (knobs are read-only), and resets
/// to the knob values whenever a knob changes.
class _CheckboxPlayground extends StatefulWidget {
  const _CheckboxPlayground({
    required this.label,
    required this.description,
    required this.errorText,
    required this.value,
    required this.isIndeterminate,
    required this.isDisabled,
  });

  final String label;
  final String? description;
  final String? errorText;
  final bool value;
  final bool isIndeterminate;
  final bool isDisabled;

  @override
  State<_CheckboxPlayground> createState() => _CheckboxPlaygroundState();
}

class _CheckboxPlaygroundState extends State<_CheckboxPlayground> {
  late bool _value = widget.value;
  late bool _isIndeterminate = widget.isIndeterminate;

  @override
  void didUpdateWidget(_CheckboxPlayground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _value = widget.value;
    if (oldWidget.isIndeterminate != widget.isIndeterminate) {
      _isIndeterminate = widget.isIndeterminate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCheckbox(
      value: _value,
      isIndeterminate: _isIndeterminate,
      isDisabled: widget.isDisabled,
      label: widget.label,
      description: widget.description,
      errorText: widget.errorText,
      onChanged: (value) => setState(() {
        _value = value;
        _isIndeterminate = false;
      }),
    );
  }
}
