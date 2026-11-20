// Use cases for TextField, Textarea and VerificationCodeInput.
// Names MUST match the React story names. Never rename them once embedded in zeroheight.
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'preview_surface.dart';

const _path = '[Components]/inputs';

Widget _sized(BuildContext context, Widget child) => previewSurface(context, SizedBox(width: 360, child: child));

// ------------------------------------------------------------------ TextField

Widget _textField(
  BuildContext context, {
  String? label = 'Account name',
  String placeholder = 'e.g. John Doe',
  String? description,
  String? errorText,
  bool required = false,
  bool disabled = false,
  String? initialValue,
  Widget? leading,
  String? prefixText,
  bool clearable = false,
  String? semanticLabel,
  AppFieldSize size = AppFieldSize.medium,
}) =>
    _sized(
      context,
      AppTextField(
        label: label,
        semanticLabel: semanticLabel,
        placeholder: context.knobs.string(label: 'placeholder', initialValue: placeholder),
        description: description,
        errorText: errorText,
        isRequired: context.knobs.boolean(label: 'required', initialValue: required),
        isDisabled: context.knobs.boolean(label: 'disabled', initialValue: disabled),
        initialValue: initialValue,
        leading: leading,
        prefixText: prefixText,
        isClearable: clearable,
        size: size,
      ),
    );

@widgetbook.UseCase(name: 'Default', type: AppTextField, path: _path)
Widget buildTextFieldDefault(BuildContext context) => _textField(context);

@widgetbook.UseCase(name: 'Required', type: AppTextField, path: _path)
Widget buildTextFieldRequired(BuildContext context) => _textField(context, required: true);

@widgetbook.UseCase(name: 'WithDescription', type: AppTextField, path: _path)
Widget buildTextFieldWithDescription(BuildContext context) => _textField(
      context,
      label: 'Notes',
      placeholder: 'Primary personal account',
      description: 'Only visible to your team.',
    );

@widgetbook.UseCase(name: 'Search', type: AppTextField, path: _path)
Widget buildTextFieldSearch(BuildContext context) => _textField(
      context,
      label: null,
      semanticLabel: 'Search accounts',
      placeholder: 'Search accounts...',
      leading: const AppIcon(AppIcons.search),
      clearable: true,
      initialValue: 'Business',
    );

@widgetbook.UseCase(name: 'WithPrefix', type: AppTextField, path: _path)
Widget buildTextFieldWithPrefix(BuildContext context) =>
    _textField(context, label: 'Amount', placeholder: '0', prefixText: 'RWF');

@widgetbook.UseCase(name: 'Error', type: AppTextField, path: _path)
Widget buildTextFieldError(BuildContext context) =>
    _textField(context, required: true, initialValue: 'J', errorText: 'Use at least 2 characters.');

@widgetbook.UseCase(name: 'Disabled', type: AppTextField, path: _path)
Widget buildTextFieldDisabled(BuildContext context) =>
    _textField(context, disabled: true, initialValue: 'Business Account');

@widgetbook.UseCase(name: 'Sizes', type: AppTextField, path: _path)
Widget buildTextFieldSizes(BuildContext context) => _sized(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final size in AppFieldSize.values) ...[
            AppTextField(semanticLabel: size.name, placeholder: '${size.name} (${size.height.round()} px)', size: size),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );

// ------------------------------------------------------------------- Textarea

@widgetbook.UseCase(name: 'Default', type: AppTextarea, path: _path)
Widget buildTextareaDefault(BuildContext context) =>
    _sized(context, const AppTextarea(label: 'Notes', placeholder: 'Primary personal account'));

@widgetbook.UseCase(name: 'WithCount', type: AppTextarea, path: _path)
Widget buildTextareaWithCount(BuildContext context) => _sized(
      context,
      const AppTextarea(
        label: 'Notes',
        initialValue: 'Used for salary payments.',
        maxLength: 200,
        showCount: true,
      ),
    );

@widgetbook.UseCase(name: 'Error', type: AppTextarea, path: _path)
Widget buildTextareaError(BuildContext context) =>
    _sized(context, const AppTextarea(label: 'Notes', isRequired: true, errorText: 'Add a note.'));

@widgetbook.UseCase(name: 'Disabled', type: AppTextarea, path: _path)
Widget buildTextareaDisabled(BuildContext context) =>
    _sized(context, const AppTextarea(label: 'Notes', isDisabled: true, initialValue: 'Read-only note'));

// ------------------------------------------------------ VerificationCodeInput

Widget _code(
  BuildContext context, {
  String? initialValue,
  String? errorText,
  bool masked = false,
  int length = 6,
  String label = 'Verification code',
  bool disabled = false,
}) =>
    previewSurface(
      context,
      AppVerificationCodeInput(
        label: label,
        length: length,
        initialValue: initialValue,
        errorText: errorText,
        isMasked: context.knobs.boolean(label: 'mask', initialValue: masked),
        isDisabled: context.knobs.boolean(label: 'disabled', initialValue: disabled),
        size: context.knobs.object.dropdown(
          label: 'size',
          options: AppFieldSize.values,
          initialOption: AppFieldSize.medium,
          labelBuilder: (value) => value.name,
        ),
      ),
    );

@widgetbook.UseCase(name: 'Default', type: AppVerificationCodeInput, path: _path)
Widget buildCodeDefault(BuildContext context) => _code(context);

@widgetbook.UseCase(name: 'Filled', type: AppVerificationCodeInput, path: _path)
Widget buildCodeFilled(BuildContext context) => _code(context, initialValue: '482913');

@widgetbook.UseCase(name: 'Error', type: AppVerificationCodeInput, path: _path)
Widget buildCodeError(BuildContext context) => _code(
      context,
      initialValue: '482910',
      errorText: 'That code is not right. Check the email and try again.',
    );

@widgetbook.UseCase(name: 'Masked', type: AppVerificationCodeInput, path: _path)
Widget buildCodeMasked(BuildContext context) =>
    _code(context, initialValue: '4829', length: 4, masked: true, label: 'PIN');

@widgetbook.UseCase(name: 'Disabled', type: AppVerificationCodeInput, path: _path)
Widget buildCodeDisabled(BuildContext context) => _code(context, disabled: true);

/// The full "Verify your email" card.
@widgetbook.UseCase(name: 'VerifyEmail', type: AppVerificationCodeInput, path: _path)
Widget buildCodeVerifyEmail(BuildContext context) {
  final t = AppTokens.of(context);
  return previewSurface(
    context,
    AppCard(
      width: 480,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIconTile(icon: AppIcon(AppIcons.mailCheck), size: AppIconTileSize.large),
            const SizedBox(height: 24),
            Text(
              'Verify your email.',
              style: AppType.style(AppType.x3l, weight: FontWeight.w800, color: t.textHeading),
            ),
            const SizedBox(height: 8),
            Text('Verification code has been sent', style: AppType.style(AppType.md, color: t.textSubtle)),
            const SizedBox(height: 24),
            const AppVerificationCodeInput(label: 'Verification code'),
            const SizedBox(height: 24),
            Text.rich(
              TextSpan(
                text: "Didn't receive the code? ",
                children: [TextSpan(text: 'Resend code in 47s', style: TextStyle(color: t.textSubtle))],
              ),
              style: AppType.style(AppType.md, color: t.textMuted),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Verify and sign in',
              size: AppButtonSize.large,
              isFullWidth: true,
              isDisabled: true,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            AppButton(label: 'Back to login', variant: AppButtonVariant.link, onPressed: () {}),
          ],
        ),
      ),
    ),
  );
}
