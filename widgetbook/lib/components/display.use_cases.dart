// Use cases for StatusBadge, Avatar, IconTile, Card, StatCard and Title.
// Names MUST match the React story names. Never rename them once embedded in zeroheight.
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'preview_surface.dart';

const _display = '[Components]/data display';
const _layout = '[Components]/layout';

// ---------------------------------------------------------------- StatusBadge

Widget _badge(BuildContext context, {required AppBadgeTone tone, required String label, bool dot = true}) {
  return previewSurface(
    context,
    AppStatusBadge(
      label: context.knobs.string(label: 'label', initialValue: label),
      tone: context.knobs.object.dropdown(
        label: 'tone',
        options: AppBadgeTone.values,
        initialOption: tone,
        labelBuilder: (value) => value.name,
      ),
      hasDot: context.knobs.boolean(label: 'dot', initialValue: dot),
      size: context.knobs.object.dropdown(
        label: 'size',
        options: AppBadgeSize.values,
        initialOption: AppBadgeSize.medium,
        labelBuilder: (value) => value.name,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Success', type: AppStatusBadge, path: _display)
Widget buildBadgeSuccess(BuildContext context) => _badge(context, tone: AppBadgeTone.success, label: 'ACTIVE');

@widgetbook.UseCase(name: 'Warning', type: AppStatusBadge, path: _display)
Widget buildBadgeWarning(BuildContext context) =>
    _badge(context, tone: AppBadgeTone.warning, label: 'Parent', dot: false);

@widgetbook.UseCase(name: 'Danger', type: AppStatusBadge, path: _display)
Widget buildBadgeDanger(BuildContext context) => _badge(context, tone: AppBadgeTone.danger, label: 'INACTIVE');

@widgetbook.UseCase(name: 'Info', type: AppStatusBadge, path: _display)
Widget buildBadgeInfo(BuildContext context) => _badge(context, tone: AppBadgeTone.info, label: 'PENDING');

@widgetbook.UseCase(name: 'Neutral', type: AppStatusBadge, path: _display)
Widget buildBadgeNeutral(BuildContext context) =>
    _badge(context, tone: AppBadgeTone.neutral, label: 'Draft', dot: false);

@widgetbook.UseCase(name: 'AllTones', type: AppStatusBadge, path: _display)
Widget buildBadgeAllTones(BuildContext context) => previewSurface(
      context,
      const Wrap(
        spacing: 8,
        children: [
          AppStatusBadge(label: 'ACTIVE', tone: AppBadgeTone.success, hasDot: true),
          AppStatusBadge(label: 'Parent', tone: AppBadgeTone.warning, hasDot: true),
          AppStatusBadge(label: 'INACTIVE', tone: AppBadgeTone.danger, hasDot: true),
          AppStatusBadge(label: 'PENDING', tone: AppBadgeTone.info, hasDot: true),
          AppStatusBadge(label: 'Draft', tone: AppBadgeTone.neutral, hasDot: true),
        ],
      ),
    );

// --------------------------------------------------------------------- Avatar

@widgetbook.UseCase(name: 'Initials', type: AppAvatar, path: _display)
Widget buildAvatarInitials(BuildContext context) => previewSurface(
      context,
      AppAvatar(
        name: context.knobs.string(label: 'name', initialValue: 'Nineth sub-account'),
        size: context.knobs.object.dropdown(
          label: 'size',
          options: AppAvatarSize.values,
          initialOption: AppAvatarSize.medium,
          labelBuilder: (value) => value.name,
        ),
        shape: context.knobs.object.dropdown(
          label: 'shape',
          options: AppAvatarShape.values,
          labelBuilder: (value) => value.name,
        ),
      ),
    );

@widgetbook.UseCase(name: 'Sizes', type: AppAvatar, path: _display)
Widget buildAvatarSizes(BuildContext context) => previewSurface(
      context,
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final size in AppAvatarSize.values) ...[
            AppAvatar(name: 'Nineth sub-account', size: size),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );

@widgetbook.UseCase(name: 'WithLabel', type: AppAvatar, path: _display)
Widget buildAvatarWithLabel(BuildContext context) => previewSurface(
      context,
      const AppAvatarLabel(title: 'Eighth sub-account', description: 'INDIVIDUAL'),
    );

@widgetbook.UseCase(name: 'WithBadge', type: AppAvatar, path: _display)
Widget buildAvatarWithBadge(BuildContext context) => previewSurface(
      context,
      const AppAvatarLabel(
        title: 'Business Account',
        description: 'BUSINESS',
        extra: AppStatusBadge(label: 'Parent', tone: AppBadgeTone.warning),
      ),
    );

// ------------------------------------------------------------------- IconTile

@widgetbook.UseCase(name: 'Default', type: AppIconTile, path: _display)
Widget buildIconTileDefault(BuildContext context) => previewSurface(
      context,
      AppIconTile(
        icon: const AppIcon(AppIcons.arrowDownToLine),
        tone: context.knobs.object.dropdown(
          label: 'tone',
          options: AppIconTileTone.values,
          labelBuilder: (value) => value.name,
        ),
        size: context.knobs.object.dropdown(
          label: 'size',
          options: AppIconTileSize.values,
          labelBuilder: (value) => value.name,
        ),
      ),
    );

@widgetbook.UseCase(name: 'Large', type: AppIconTile, path: _display)
Widget buildIconTileLarge(BuildContext context) => previewSurface(
      context,
      const AppIconTile(icon: AppIcon(AppIcons.mailCheck), size: AppIconTileSize.large),
    );

@widgetbook.UseCase(name: 'Tones', type: AppIconTile, path: _display)
Widget buildIconTileTones(BuildContext context) => previewSurface(
      context,
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final tone in AppIconTileTone.values) ...[
            AppIconTile(icon: const AppIcon(AppIcons.arrowDownToLine), tone: tone),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );

// ----------------------------------------------------------------------- Card

const _cardText = 'Card content goes here. Put a Title, a list, a form or a table inside.';

Widget _card(BuildContext context, AppCardVariant variant, {VoidCallback? onTap, String text = _cardText}) {
  return previewSurface(
    context,
    AppCard(
      width: 360,
      variant: variant,
      padding: context.knobs.object.dropdown(
        label: 'padding',
        options: AppCardPadding.values,
        initialOption: AppCardPadding.large,
        labelBuilder: (value) => value.name,
      ),
      onTap: onTap,
      semanticLabel: onTap == null ? null : 'Example card',
      child: Text(text),
    ),
  );
}

@widgetbook.UseCase(name: 'Elevated', type: AppCard, path: _layout)
Widget buildCardElevated(BuildContext context) => _card(context, AppCardVariant.elevated);

@widgetbook.UseCase(name: 'Outlined', type: AppCard, path: _layout)
Widget buildCardOutlined(BuildContext context) => _card(context, AppCardVariant.outlined);

@widgetbook.UseCase(name: 'Flat', type: AppCard, path: _layout)
Widget buildCardFlat(BuildContext context) => _card(context, AppCardVariant.flat);

@widgetbook.UseCase(name: 'Interactive', type: AppCard, path: _layout)
Widget buildCardInteractive(BuildContext context) => _card(
      context,
      AppCardVariant.elevated,
      onTap: () {},
      text: 'Hover me: the whole card is clickable.',
    );

// ------------------------------------------------------------------- StatCard

Widget _stat(BuildContext context, {AppStatTrend? trend, bool loading = false}) => previewSurface(
      context,
      SizedBox(
        width: 400,
        child: AppStatCard(
          label: context.knobs.string(label: 'label', initialValue: 'Money in'),
          value: context.knobs.string(label: 'value', initialValue: 'RWF 1,615'),
          caption: context.knobs.string(label: 'caption', initialValue: 'Credits posted to your accounts'),
          icon: const AppIcon(AppIcons.arrowDownToLine),
          trend: trend,
          isLoading: context.knobs.boolean(label: 'loading', initialValue: loading),
        ),
      ),
    );

@widgetbook.UseCase(name: 'Default', type: AppStatCard, path: _display)
Widget buildStatCardDefault(BuildContext context) => _stat(context);

@widgetbook.UseCase(name: 'WithTrend', type: AppStatCard, path: _display)
Widget buildStatCardWithTrend(BuildContext context) => _stat(
      context,
      trend: const AppStatTrend(value: '+12%', direction: AppTrendDirection.up, label: 'vs last week'),
    );

@widgetbook.UseCase(name: 'Loading', type: AppStatCard, path: _display)
Widget buildStatCardLoading(BuildContext context) => _stat(context, loading: true);

@widgetbook.UseCase(name: 'Group', type: AppStatCard, path: _display)
Widget buildStatCardGroup(BuildContext context) => previewSurface(
      context,
      const SizedBox(
        width: 1100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppStatCard(
                label: 'Money in',
                value: 'RWF 1,615',
                caption: 'Credits posted to your accounts',
                icon: AppIcon(AppIcons.arrowDownToLine),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AppStatCard(
                label: 'Money out',
                value: 'RWF 872',
                caption: 'Debits posted from your accounts',
                icon: AppIcon(AppIcons.arrowUpFromLine),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AppStatCard(
                label: 'Net',
                value: 'RWF 743',
                caption: 'Money in minus money out',
                icon: AppIcon(AppIcons.hourglass),
              ),
            ),
          ],
        ),
      ),
    );

// ---------------------------------------------------------------------- Title

@widgetbook.UseCase(name: 'Page', type: AppTitle, path: _layout)
Widget buildTitlePage(BuildContext context) => previewSurface(
      context,
      AppTitle(
        title: context.knobs.string(label: 'title', initialValue: 'Accounts'),
        description: context.knobs.string(label: 'description', initialValue: 'Manage accounts.'),
      ),
    );

@widgetbook.UseCase(name: 'WithActions', type: AppTitle, path: _layout)
Widget buildTitleWithActions(BuildContext context) => previewSurface(
      context,
      SizedBox(
        width: 900,
        child: AppTitle(
          title: 'Accounts',
          description: 'Manage accounts.',
          actions: [
            AppButton(
              label: 'Filters',
              variant: AppButtonVariant.secondary,
              leadingIcon: const AppIcon(AppIcons.filter),
              onPressed: () {},
            ),
            AppButton(label: 'New account', leadingIcon: const AppIcon(AppIcons.plus), onPressed: () {}),
          ],
        ),
      ),
    );

@widgetbook.UseCase(name: 'Section', type: AppTitle, path: _layout)
Widget buildTitleSection(BuildContext context) => previewSurface(
      context,
      const SizedBox(
        width: 900,
        child: AppTitle(
          size: AppTitleSize.section,
          title: 'Transaction volume',
          description: 'Money in is everything received, money out is everything sent, and net is the difference.',
        ),
      ),
    );

@widgetbook.UseCase(name: 'Card', type: AppTitle, path: _layout)
Widget buildTitleCard(BuildContext context) => previewSurface(
      context,
      const AppTitle(size: AppTitleSize.card, title: 'Recent activity', description: 'Last 7 days'),
    );
