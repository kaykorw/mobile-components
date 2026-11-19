// Use-case names (Primary, Secondary, Danger, Disabled, Loading) MUST match
// the React story names. Never rename them once embedded in zeroheight.
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'preview_surface.dart';

/// Shared builder so every use case exposes the same knobs.
Widget _buildButton(
  BuildContext context, {
  required AppButtonVariant variant,
  String label = 'Button',
  bool disabled = false,
  bool loading = false,
}) {
  return previewSurface(
    context,
    AppButton(
      label: context.knobs.string(label: 'label', initialValue: label),
      variant: variant,
      size: context.knobs.object.dropdown(
        label: 'size',
        options: AppButtonSize.values,
        initialOption: AppButtonSize.medium,
        labelBuilder: (value) => value.name,
      ),
      isDisabled: context.knobs.boolean(label: 'disabled', initialValue: disabled),
      isLoading: context.knobs.boolean(label: 'loading', initialValue: loading),
      onPressed: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Primary', type: AppButton, path: '[Components]/actions')
Widget buildAppButtonPrimary(BuildContext context) =>
    _buildButton(context, variant: AppButtonVariant.primary);

@widgetbook.UseCase(name: 'Secondary', type: AppButton, path: '[Components]/actions')
Widget buildAppButtonSecondary(BuildContext context) =>
    _buildButton(context, variant: AppButtonVariant.secondary);

@widgetbook.UseCase(name: 'Danger', type: AppButton, path: '[Components]/actions')
Widget buildAppButtonDanger(BuildContext context) =>
    _buildButton(context, variant: AppButtonVariant.danger, label: 'Delete');

@widgetbook.UseCase(name: 'Disabled', type: AppButton, path: '[Components]/actions')
Widget buildAppButtonDisabled(BuildContext context) =>
    _buildButton(context, variant: AppButtonVariant.primary, disabled: true);

@widgetbook.UseCase(name: 'Loading', type: AppButton, path: '[Components]/actions')
Widget buildAppButtonLoading(BuildContext context) =>
    _buildButton(context, variant: AppButtonVariant.primary, loading: true);
