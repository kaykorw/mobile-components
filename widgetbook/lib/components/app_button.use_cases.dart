// Use-case names MUST match the React story names. Never rename them once
// embedded in zeroheight.
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'preview_surface.dart';

const _path = '[Components]/actions';

Widget _button(
  BuildContext context, {
  AppButtonVariant variant = AppButtonVariant.primary,
  String label = 'Button',
  Widget? leadingIcon,
  bool selected = false,
  bool disabled = false,
  bool loading = false,
  bool fullWidth = false,
  AppButtonSize size = AppButtonSize.medium,
}) {
  final button = AppButton(
    label: context.knobs.string(label: 'label', initialValue: label),
    variant: context.knobs.object.dropdown(
      label: 'variant',
      options: AppButtonVariant.values,
      initialOption: variant,
      labelBuilder: (value) => value.name,
    ),
    size: context.knobs.object.dropdown(
      label: 'size',
      options: AppButtonSize.values,
      initialOption: size,
      labelBuilder: (value) => value.name,
    ),
    leadingIcon: leadingIcon,
    isSelected: context.knobs.boolean(label: 'selected', initialValue: selected),
    isDisabled: context.knobs.boolean(label: 'disabled', initialValue: disabled),
    isLoading: context.knobs.boolean(label: 'loading', initialValue: loading),
    isFullWidth: fullWidth,
    onPressed: () {},
  );
  return previewSurface(context, fullWidth ? SizedBox(width: 400, child: button) : button);
}

@widgetbook.UseCase(name: 'Primary', type: AppButton, path: _path)
Widget buildAppButtonPrimary(BuildContext context) => _button(context);

@widgetbook.UseCase(name: 'Secondary', type: AppButton, path: _path)
Widget buildAppButtonSecondary(BuildContext context) =>
    _button(context, variant: AppButtonVariant.secondary);

@widgetbook.UseCase(name: 'Ghost', type: AppButton, path: _path)
Widget buildAppButtonGhost(BuildContext context) => _button(
      context,
      variant: AppButtonVariant.ghost,
      label: 'Reset',
      leadingIcon: const AppIcon(AppIcons.refresh),
    );

@widgetbook.UseCase(name: 'Link', type: AppButton, path: _path)
Widget buildAppButtonLink(BuildContext context) =>
    _button(context, variant: AppButtonVariant.link, label: 'Back to login');

@widgetbook.UseCase(name: 'Danger', type: AppButton, path: _path)
Widget buildAppButtonDanger(BuildContext context) =>
    _button(context, variant: AppButtonVariant.danger, label: 'Delete');

@widgetbook.UseCase(name: 'WithIcon', type: AppButton, path: _path)
Widget buildAppButtonWithIcon(BuildContext context) =>
    _button(context, label: 'New account', leadingIcon: const AppIcon(AppIcons.plus));

@widgetbook.UseCase(name: 'Selected', type: AppButton, path: _path)
Widget buildAppButtonSelected(BuildContext context) => _button(
      context,
      variant: AppButtonVariant.secondary,
      label: 'Filters',
      leadingIcon: const AppIcon(AppIcons.filter),
      selected: true,
    );

@widgetbook.UseCase(name: 'IconOnly', type: AppButton, path: _path)
Widget buildAppButtonIconOnly(BuildContext context) => previewSurface(
      context,
      AppButton.icon(
        icon: const AppIcon(AppIcons.more),
        semanticLabel: 'More actions',
        onPressed: () {},
      ),
    );

@widgetbook.UseCase(name: 'FullWidth', type: AppButton, path: _path)
Widget buildAppButtonFullWidth(BuildContext context) =>
    _button(context, label: 'Verify and sign in', size: AppButtonSize.large, fullWidth: true);

@widgetbook.UseCase(name: 'Disabled', type: AppButton, path: _path)
Widget buildAppButtonDisabled(BuildContext context) => _button(context, disabled: true);

@widgetbook.UseCase(name: 'Loading', type: AppButton, path: _path)
Widget buildAppButtonLoading(BuildContext context) => _button(context, loading: true);
