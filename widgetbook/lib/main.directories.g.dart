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
import 'package:widgetbook_workspace/components/app_calendar.use_cases.dart'
    as _widgetbook_workspace_components_app_calendar_use_cases;
import 'package:widgetbook_workspace/components/app_checkbox.use_cases.dart'
    as _widgetbook_workspace_components_app_checkbox_use_cases;

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
      _widgetbook.WidgetbookFolder(
        name: 'inputs',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppCalendar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Range',
                builder: _widgetbook_workspace_components_app_calendar_use_cases
                    .buildAppCalendarRange,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Restricted',
                builder: _widgetbook_workspace_components_app_calendar_use_cases
                    .buildAppCalendarRestricted,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Single',
                builder: _widgetbook_workspace_components_app_calendar_use_cases
                    .buildAppCalendarSingle,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppCheckbox',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Checked',
                builder: _widgetbook_workspace_components_app_checkbox_use_cases
                    .buildAppCheckboxChecked,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_app_checkbox_use_cases
                    .buildAppCheckboxDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled',
                builder: _widgetbook_workspace_components_app_checkbox_use_cases
                    .buildAppCheckboxDisabled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Error',
                builder: _widgetbook_workspace_components_app_checkbox_use_cases
                    .buildAppCheckboxError,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Indeterminate',
                builder: _widgetbook_workspace_components_app_checkbox_use_cases
                    .buildAppCheckboxIndeterminate,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
