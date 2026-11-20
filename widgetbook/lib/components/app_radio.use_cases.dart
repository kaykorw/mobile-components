// Use-case names MUST match the React story names.
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'preview_surface.dart';

const _path = '[Components]/inputs';

const _status = [
  AppRadioOption(value: 'ACTIVE', label: 'ACTIVE'),
  AppRadioOption(value: 'INACTIVE', label: 'INACTIVE'),
];

Widget _group(
  BuildContext context, {
  List<AppRadioOption<String>> options = _status,
  String? value,
  String? label,
  AppRadioOrientation orientation = AppRadioOrientation.vertical,
  bool disabled = false,
  String? errorText,
}) =>
    previewSurface(
      context,
      _RadioPlayground(
        options: options,
        initialValue: value,
        label: label,
        orientation: orientation,
        disabled: context.knobs.boolean(label: 'disabled', initialValue: disabled),
        errorText: errorText,
      ),
    );

@widgetbook.UseCase(name: 'Default', type: AppRadioGroup, path: _path)
Widget buildRadioDefault(BuildContext context) => _group(context);

@widgetbook.UseCase(name: 'Selected', type: AppRadioGroup, path: _path)
Widget buildRadioSelected(BuildContext context) => _group(context, value: 'ACTIVE');

@widgetbook.UseCase(name: 'WithDescriptions', type: AppRadioGroup, path: _path)
Widget buildRadioWithDescriptions(BuildContext context) => _group(
      context,
      label: 'Account type',
      value: 'INDIVIDUAL',
      options: const [
        AppRadioOption(value: 'INDIVIDUAL', label: 'Individual', description: 'For one person.'),
        AppRadioOption(value: 'BUSINESS', label: 'Business', description: 'Can hold sub-accounts.'),
      ],
    );

@widgetbook.UseCase(name: 'Horizontal', type: AppRadioGroup, path: _path)
Widget buildRadioHorizontal(BuildContext context) =>
    _group(context, value: 'ACTIVE', orientation: AppRadioOrientation.horizontal);

@widgetbook.UseCase(name: 'Disabled', type: AppRadioGroup, path: _path)
Widget buildRadioDisabled(BuildContext context) => _group(context, value: 'ACTIVE', disabled: true);

@widgetbook.UseCase(name: 'Error', type: AppRadioGroup, path: _path)
Widget buildRadioError(BuildContext context) => _group(context, label: 'Status', errorText: 'Pick a status.');

class _RadioPlayground extends StatefulWidget {
  const _RadioPlayground({
    required this.options,
    required this.initialValue,
    required this.label,
    required this.orientation,
    required this.disabled,
    required this.errorText,
  });

  final List<AppRadioOption<String>> options;
  final String? initialValue;
  final String? label;
  final AppRadioOrientation orientation;
  final bool disabled;
  final String? errorText;

  @override
  State<_RadioPlayground> createState() => _RadioPlaygroundState();
}

class _RadioPlaygroundState extends State<_RadioPlayground> {
  late String? _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return AppRadioGroup<String>(
      options: widget.options,
      value: _value,
      label: widget.label,
      semanticLabel: widget.label == null ? 'Status' : null,
      orientation: widget.orientation,
      isDisabled: widget.disabled,
      errorText: widget.errorText,
      onChanged: (value) => setState(() => _value = value),
    );
  }
}
