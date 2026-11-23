// AppDialog / showAppDialog / showAppSheet: Flutter counterparts of React
// <Dialog> and <Sheet>. Centered modal or full-height side sheet over a
// blurred, lightly tinted page (as in the New Account screenshot).
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

/// center: modal in the middle. right / left: side sheet. Same names as React.
enum AppDialogPlacement { center, right, left }

/// center: 400 / 520 / 720 px wide. Sheets: 360 / 440 / 560 px. Same names as React.
enum AppDialogSize { small, medium, large }

/// stretch: full-width stacked buttons (sheets). end: right-aligned row (center).
enum AppDialogFooterLayout { end, stretch }

typedef AppDialogBuilder = Widget Function(BuildContext context, VoidCallback close);

/// The dialog surface: header (title, description, ×), scrollable body, footer.
/// Use it directly inside your own route, or through [showAppDialog] / [showAppSheet].
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.onClose,
    this.description,
    this.body,
    this.footer = const [],
    this.placement = AppDialogPlacement.center,
    this.size = AppDialogSize.medium,
    this.footerLayout,
    this.hideCloseButton = false,
    this.closeLabel = 'Close',
  });

  /// Heading, e.g. "New Account".
  final String title;

  /// Text under the heading.
  final String? description;

  /// Usually a form. Scrolls when taller than the screen.
  final Widget? body;

  /// Actions, e.g. Cancel + Create Account.
  final List<Widget> footer;
  final VoidCallback onClose;
  final AppDialogPlacement placement;
  final AppDialogSize size;
  final AppDialogFooterLayout? footerLayout;
  final bool hideCloseButton;

  /// Accessible name of the × button.
  final String closeLabel;

  bool get _isSheet => placement != AppDialogPlacement.center;

  double get width => switch ((_isSheet, size)) {
        (false, AppDialogSize.small) => 400,
        (false, AppDialogSize.medium) => 520,
        (false, AppDialogSize.large) => 720,
        (true, AppDialogSize.small) => 360,
        (true, AppDialogSize.medium) => 440,
        (true, AppDialogSize.large) => 560,
      };

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final layout = footerLayout ?? (_isSheet ? AppDialogFooterLayout.stretch : AppDialogFooterLayout.end);
    final divider = BorderSide(color: t.borderInput);
    final bodyWidget = body;

    final header = Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.s6, AppSpacing.s6, AppSpacing.s6, AppSpacing.s5),
      decoration: BoxDecoration(border: Border(bottom: divider)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(title, style: AppType.style(20, weight: FontWeight.w700, color: t.textStrong, height: 1.25)),
                ),
                if (description case final text?) ...[
                  const SizedBox(height: 6),
                  Text(text, style: AppType.style(AppType.md, color: t.textMuted, height: 1.45)),
                ],
              ],
            ),
          ),
          if (!hideCloseButton) ...[
            const SizedBox(width: AppSpacing.s4),
            AppPressable(
              onTap: onClose,
              semanticLabel: closeLabel,
              builder: (context, states) => AppFocusRing(
                visible: states.contains(WidgetState.focused),
                child: AnimatedContainer(
                  duration: AppDurations.fast,
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: states.contains(WidgetState.hovered) ? t.surfaceMuted : Colors.transparent,
                    borderRadius: AppRadius.all(AppRadius.md),
                  ),
                  child: AppIcon(AppIcons.close, size: 20, color: t.textStrong),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    Widget? footerWidget;
    if (footer.isNotEmpty) {
      footerWidget = Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.s6, AppSpacing.s4, AppSpacing.s6, AppSpacing.s6),
        decoration: BoxDecoration(border: Border(top: divider)),
        child: layout == AppDialogFooterLayout.stretch
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < footer.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.s3),
                    footer[i],
                  ],
                ],
              )
            : Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.s3,
                runSpacing: AppSpacing.s3,
                children: footer,
              ),
      );
    }

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title,
      // Shadow outside the clipped surface; width shrinks to fit small screens.
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: AppShadows.lg,
          borderRadius: _isSheet ? null : AppRadius.all(AppRadius.xl),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: Material(
        color: t.surface,
        shape: _isSheet
            ? Border(
                left: placement == AppDialogPlacement.right ? BorderSide(color: t.border) : BorderSide.none,
                right: placement == AppDialogPlacement.left ? BorderSide(color: t.border) : BorderSide.none,
              )
            : RoundedRectangleBorder(
                borderRadius: AppRadius.all(AppRadius.xl),
                side: BorderSide(color: t.border),
              ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: _isSheet ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                if (bodyWidget != null)
                  Flexible(
                    fit: _isSheet ? FlexFit.tight : FlexFit.loose,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.s6),
                      child: bodyWidget,
                    ),
                  )
                else if (_isSheet)
                  const Spacer(),
                if (footerWidget != null) footerWidget,
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

/// Opens a centered modal dialog. Returns the value passed to `Navigator.pop`.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  String? description,
  AppDialogBuilder? bodyBuilder,
  AppDialogBuilder? footerBuilder,
  AppDialogSize size = AppDialogSize.small,
  AppDialogFooterLayout? footerLayout,
  bool isDismissible = true,
  bool hideCloseButton = false,
}) =>
    _showAppDialog<T>(
      context: context,
      title: title,
      description: description,
      bodyBuilder: bodyBuilder,
      footerBuilder: footerBuilder,
      placement: AppDialogPlacement.center,
      size: size,
      footerLayout: footerLayout,
      isDismissible: isDismissible,
      hideCloseButton: hideCloseButton,
    );

/// Opens a full-height side sheet (like "New Account"). Returns the value passed to `Navigator.pop`.
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required String title,
  String? description,
  AppDialogBuilder? bodyBuilder,
  AppDialogBuilder? footerBuilder,
  AppDialogPlacement side = AppDialogPlacement.right,
  AppDialogSize size = AppDialogSize.medium,
  AppDialogFooterLayout? footerLayout,
  bool isDismissible = true,
  bool hideCloseButton = false,
}) =>
    _showAppDialog<T>(
      context: context,
      title: title,
      description: description,
      bodyBuilder: bodyBuilder,
      footerBuilder: footerBuilder,
      placement: side == AppDialogPlacement.center ? AppDialogPlacement.right : side,
      size: size,
      footerLayout: footerLayout,
      isDismissible: isDismissible,
      hideCloseButton: hideCloseButton,
    );

Future<T?> _showAppDialog<T>({
  required BuildContext context,
  required String title,
  required String? description,
  required AppDialogBuilder? bodyBuilder,
  required AppDialogBuilder? footerBuilder,
  required AppDialogPlacement placement,
  required AppDialogSize size,
  required AppDialogFooterLayout? footerLayout,
  required bool isDismissible,
  required bool hideCloseButton,
}) {
  final isSheet = placement != AppDialogPlacement.center;
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: false, // the blurred layer below handles taps
    barrierColor: Colors.transparent,
    barrierLabel: title,
    transitionDuration: AppDurations.normal,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      void close() => Navigator.of(dialogContext).pop();
      final footer = footerBuilder?.call(dialogContext, close);
      final dialog = AppDialog(
        title: title,
        description: description,
        body: bodyBuilder?.call(dialogContext, close),
        footer: footer == null ? const [] : [footer],
        placement: placement,
        size: size,
        footerLayout: footerLayout,
        hideCloseButton: hideCloseButton,
        onClose: close,
      );
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final Offset begin = switch (placement) {
        AppDialogPlacement.right => const Offset(0.05, 0),
        AppDialogPlacement.left => const Offset(-0.05, 0),
        AppDialogPlacement.center => const Offset(0, 0.02),
      };
      final animatedDialog = FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(begin: begin, end: Offset.zero).animate(curved),
          child: dialog,
        ),
      );
      return CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): () {
            if (isDismissible) close();
          },
        },
        child: FocusScope(
          autofocus: true,
          child: Stack(
            children: [
              Positioned.fill(
                child: FadeTransition(
                  opacity: curved,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: isDismissible ? close : null,
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: ColoredBox(color: AppTokens.of(dialogContext).overlay),
                    ),
                  ),
                ),
              ),
              if (isSheet)
                Align(
                  alignment: placement == AppDialogPlacement.right ? Alignment.centerRight : Alignment.centerLeft,
                  child: animatedDialog,
                )
              else
                SafeArea(
                  child: Center(
                    child: Padding(padding: const EdgeInsets.all(AppSpacing.s4), child: animatedDialog),
                  ),
                ),
            ],
          ),
        ),
      );
    },
    // The page builder animates the panel and the backdrop separately.
    transitionBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}
