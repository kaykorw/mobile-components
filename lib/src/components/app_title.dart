// AppTitle: Flutter counterpart of React <Title>.
import 'package:flutter/material.dart';

import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// page = 24 px (page header), section = 18 px (card/chart header), card = 16 px. Same names as React.
enum AppTitleSize { page, section, card }

/// Page or section heading with an optional description and actions, as on the Accounts page.
class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
    required this.title,
    this.description,
    this.actions = const [],
    this.leading,
    this.size = AppTitleSize.page,
  });

  /// Heading text, e.g. "Accounts".
  final String title;

  /// Text under the heading, e.g. "Manage accounts."
  final String? description;

  /// Buttons or inputs on the right. They wrap under the title on narrow screens.
  final List<Widget> actions;

  /// Something before the title, e.g. a back button or an AppIconTile.
  final Widget? leading;
  final AppTitleSize size;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final (double fontSize, FontWeight weight) = switch (size) {
      AppTitleSize.page => (AppType.x2l, FontWeight.w700),
      AppTitleSize.section => (AppType.xl, FontWeight.w600),
      AppTitleSize.card => (AppType.lg, FontWeight.w600),
    };

    final text = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: AppType.style(
              fontSize,
              weight: weight,
              color: t.textHeading,
              height: 1.2,
              letterSpacing: size == AppTitleSize.page ? -0.24 : null,
            ),
          ),
        ),
        if (description case final value?) ...[
          const SizedBox(height: 6),
          Text(
            value,
            style: AppType.style(
              size == AppTitleSize.card ? AppType.sm : AppType.md,
              color: t.textMuted,
              height: 1.45,
            ),
          ),
        ],
      ],
    );

    final main = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading case final lead?) ...[lead, const SizedBox(width: AppSpacing.s3)],
        Flexible(child: text),
      ],
    );

    if (actions.isEmpty) return main;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacing.s4,
      runSpacing: AppSpacing.s4,
      children: [
        main,
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: actions,
        ),
      ],
    );
  }
}
