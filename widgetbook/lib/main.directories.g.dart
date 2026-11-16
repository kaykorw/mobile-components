// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:widgetbook/widgetbook.dart' as _widgetbook;
import 'package:widgetbook_workspace/components/app_button.use_cases.dart'
    as _widgetbook_workspace_components_app_button_use_cases;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Components',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'actions',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Danger',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonDanger,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonDisabled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Loading',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonLoading,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Primary',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonPrimary,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Secondary',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonSecondary,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
