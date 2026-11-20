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
import 'package:widgetbook_workspace/components/app_checkbox.use_cases.dart'
    as _widgetbook_workspace_components_app_checkbox_use_cases;
import 'package:widgetbook_workspace/components/app_radio.use_cases.dart'
    as _widgetbook_workspace_components_app_radio_use_cases;
import 'package:widgetbook_workspace/components/data.use_cases.dart'
    as _widgetbook_workspace_components_data_use_cases;
import 'package:widgetbook_workspace/components/display.use_cases.dart'
    as _widgetbook_workspace_components_display_use_cases;
import 'package:widgetbook_workspace/components/inputs.use_cases.dart'
    as _widgetbook_workspace_components_inputs_use_cases;
import 'package:widgetbook_workspace/components/overlays.use_cases.dart'
    as _widgetbook_workspace_components_overlays_use_cases;

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
                name: 'FullWidth',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonFullWidth,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Ghost',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonGhost,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'IconOnly',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonIconOnly,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Link',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonLink,
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
              _widgetbook.WidgetbookUseCase(
                name: 'Selected',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonSelected,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithIcon',
                builder: _widgetbook_workspace_components_app_button_use_cases
                    .buildAppButtonWithIcon,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'data display',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppAvatar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Initials',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildAvatarInitials,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Sizes',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildAvatarSizes,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithBadge',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildAvatarWithBadge,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithLabel',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildAvatarWithLabel,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppBarChart',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Empty',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildBarChartEmpty,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Grouped',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildBarChartGrouped,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'InCard',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildBarChartInCard,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'SingleSeries',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildBarChartSingleSeries,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Stacked',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildBarChartStacked,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppIconTile',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildIconTileDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Large',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildIconTileLarge,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Tones',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildIconTileTones,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppStatCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildStatCardDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Group',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildStatCardGroup,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Loading',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildStatCardLoading,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithTrend',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildStatCardWithTrend,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppStatusBadge',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'AllTones',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildBadgeAllTones,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Danger',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildBadgeDanger,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Info',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildBadgeInfo,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Neutral',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildBadgeNeutral,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Success',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildBadgeSuccess,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Warning',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildBadgeWarning,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppTable',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Clickable',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildTableClickable,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Compact',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildTableCompact,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildTableDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Empty',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildTableEmpty,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Loading',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildTableLoading,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Sortable',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildTableSortable,
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
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildCalendarRange,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Restricted',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildCalendarRestricted,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Single',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildCalendarSingle,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Sizes',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildCalendarSizes,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'TwoMonths',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildCalendarTwoMonths,
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
          _widgetbook.WidgetbookComponent(
            name: 'AppDateRangePicker',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'CustomPresets',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildRangeCustomPresets,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildRangeDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Error',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildRangeError,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'SingleDate',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildRangeSingleDate,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithLabel',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildRangeWithLabel,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithValue',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildRangeWithValue,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithoutPresets',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildRangeWithoutPresets,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppRadioGroup',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_app_radio_use_cases
                    .buildRadioDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled',
                builder: _widgetbook_workspace_components_app_radio_use_cases
                    .buildRadioDisabled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Error',
                builder: _widgetbook_workspace_components_app_radio_use_cases
                    .buildRadioError,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Horizontal',
                builder: _widgetbook_workspace_components_app_radio_use_cases
                    .buildRadioHorizontal,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Selected',
                builder: _widgetbook_workspace_components_app_radio_use_cases
                    .buildRadioSelected,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithDescriptions',
                builder: _widgetbook_workspace_components_app_radio_use_cases
                    .buildRadioWithDescriptions,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppSelect',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildSelectDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildSelectDisabled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Error',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildSelectError,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Placeholder',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildSelectPlaceholder,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppTextField',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextFieldDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextFieldDisabled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Error',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextFieldError,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Required',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextFieldRequired,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Search',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextFieldSearch,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Sizes',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextFieldSizes,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithDescription',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextFieldWithDescription,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithPrefix',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextFieldWithPrefix,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppTextarea',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextareaDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextareaDisabled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Error',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextareaError,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithCount',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildTextareaWithCount,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppVerificationCodeInput',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildCodeDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildCodeDisabled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Error',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildCodeError,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Filled',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildCodeFilled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Masked',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildCodeMasked,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'VerifyEmail',
                builder: _widgetbook_workspace_components_inputs_use_cases
                    .buildCodeVerifyEmail,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'layout',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Elevated',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildCardElevated,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Flat',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildCardFlat,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildCardInteractive,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Outlined',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildCardOutlined,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppTitle',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Card',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildTitleCard,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Page',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildTitlePage,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Section',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildTitleSection,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithActions',
                builder: _widgetbook_workspace_components_display_use_cases
                    .buildTitleWithActions,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'navigation',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppPagination',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Compact',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildPaginationCompact,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildPaginationDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'ManyPages',
                builder: _widgetbook_workspace_components_data_use_cases
                    .buildPaginationManyPages,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'overlays',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppDialog',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildDialogDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Large',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildDialogLarge,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'NotDismissible',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildDialogNotDismissible,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Sheet',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildDialogSheet,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppMenuItem',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Categories',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildMenuCategories,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildMenuDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Presets',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildMenuPresets,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Selected',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildMenuSelected,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithIcons',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildMenuWithIcons,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'AppPopover',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'ActionsMenu',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildPopoverActionsMenu,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildPopoverDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Filters',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildPopoverFilters,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'WithTitle',
                builder: _widgetbook_workspace_components_overlays_use_cases
                    .buildPopoverWithTitle,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
