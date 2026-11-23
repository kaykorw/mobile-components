// AppPopover: Flutter counterpart of React <Popover>.
// Panel anchored to a trigger, drawn in the nearest Overlay. Flips above the
// trigger when there's no room below. Esc or a tap outside closes it, and
// focus returns to where it was.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// Same names as React `placement`.
enum AppPopoverPlacement { bottomStart, bottomEnd, bottom, topStart, topEnd, top }

/// Open/close an [AppPopover] from outside, e.g. after an async action.
class AppPopoverController extends ChangeNotifier {
  bool _isOpen = false;
  bool get isOpen => _isOpen;

  void open() => _set(true);
  void close() => _set(false);
  void toggle() => _set(!_isOpen);

  void _set(bool value) {
    if (_isOpen == value) return;
    _isOpen = value;
    notifyListeners();
  }
}

typedef AppPopoverTriggerBuilder = Widget Function(BuildContext context, bool isOpen, VoidCallback toggle);
typedef AppPopoverContentBuilder = Widget Function(BuildContext context, VoidCallback close);

class AppPopover extends StatefulWidget {
  const AppPopover({
    super.key,
    required this.triggerBuilder,
    required this.contentBuilder,
    this.controller,
    this.initiallyOpen = false,
    this.onOpenChanged,
    this.placement = AppPopoverPlacement.bottomStart,
    this.offset = 8,
    this.width,
    this.matchTriggerWidth = false,
    this.title,
    this.footerBuilder,
    this.isFlush = false,
    this.closeOnOutsideTap = true,
    this.semanticLabel,
  });

  /// Builds the trigger. Call `toggle` from its onPressed. Use `isOpen` to style it,
  /// e.g. `AppButton(label: 'Filters', isSelected: isOpen, onPressed: toggle)`.
  final AppPopoverTriggerBuilder triggerBuilder;

  /// Builds the panel content. Call `close` from Done/Cancel buttons.
  final AppPopoverContentBuilder contentBuilder;
  final AppPopoverController? controller;

  /// Opens after the first frame (for previews).
  final bool initiallyOpen;
  final ValueChanged<bool>? onOpenChanged;
  final AppPopoverPlacement placement;

  /// Gap between trigger and panel.
  final double offset;

  /// Fixed panel width. By default the content decides.
  final double? width;

  /// Make the panel as wide as the trigger (selects, pickers).
  final bool matchTriggerWidth;

  /// Heading row with a divider, e.g. "Filters".
  final String? title;

  /// Footer row with a divider, e.g. Reset + Done.
  final AppPopoverContentBuilder? footerBuilder;

  /// Remove the panel's inner padding (menus, custom layouts).
  final bool isFlush;
  final bool closeOnOutsideTap;

  /// Accessible name when there's no [title].
  final String? semanticLabel;

  @override
  State<AppPopover> createState() => _AppPopoverState();
}

class _AppPopoverState extends State<AppPopover> {
  final OverlayPortalController _portal = OverlayPortalController();
  final GlobalKey _triggerKey = GlobalKey();
  final FocusScopeNode _panelScope = FocusScopeNode();
  final Object _tapGroup = Object();
  AppPopoverController? _ownController;
  FocusNode? _returnFocusTo;

  AppPopoverController get _controller => widget.controller ?? (_ownController ??= AppPopoverController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_sync);
    if (widget.initiallyOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.open();
      });
    }
  }

  @override
  void didUpdateWidget(AppPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?.removeListener(_sync);
      _controller.addListener(_sync);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_sync);
    _ownController?.dispose();
    _panelScope.dispose();
    super.dispose();
  }

  void _sync() {
    final open = _controller.isOpen;
    if (open == _portal.isShowing) return;
    if (open) {
      _returnFocusTo = FocusManager.instance.primaryFocus;
      _portal.show();
    } else {
      _portal.hide();
      _returnFocusTo?.requestFocus();
      _returnFocusTo = null;
    }
    widget.onOpenChanged?.call(open);
    setState(() {});
  }

  void _toggle() => _controller.toggle();
  void _close() => _controller.close();

  Rect? _anchorRect(BuildContext overlayContext) {
    final trigger = _triggerKey.currentContext?.findRenderObject();
    final overlay = Overlay.maybeOf(overlayContext)?.context.findRenderObject();
    if (trigger is! RenderBox || overlay is! RenderBox || !trigger.hasSize) return null;
    final topLeft = trigger.localToGlobal(Offset.zero, ancestor: overlay);
    return topLeft & trigger.size;
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _buildPanel,
      child: TapRegion(
        groupId: _tapGroup,
        child: KeyedSubtree(
          key: _triggerKey,
          child: widget.triggerBuilder(context, _controller.isOpen, _toggle),
        ),
      ),
    );
  }

  Widget _buildPanel(BuildContext context) {
    final t = AppTokens.of(context);
    final anchor = _anchorRect(context);
    if (anchor == null) return const SizedBox.shrink();

    final title = widget.title;
    final footer = widget.footerBuilder?.call(context, _close);
    final width = widget.matchTriggerWidth ? anchor.width : widget.width;

    Widget panel = Container(
      width: width,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: AppRadius.all(AppRadius.lg),
        border: Border.all(color: t.border),
        boxShadow: AppShadows.md,
      ),
      clipBehavior: Clip.antiAlias,
      child: DefaultTextStyle.merge(
        style: AppType.style(AppType.md, color: t.text),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5, vertical: AppSpacing.s4),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: t.borderSubtle))),
                child: Semantics(
                  header: true,
                  child: Text(title, style: AppType.style(AppType.md, weight: FontWeight.w600, color: t.textHeading)),
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(widget.isFlush ? 0 : AppSpacing.s4),
                  child: widget.contentBuilder(context, _close),
                ),
              ),
            ),
            if (footer != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: t.borderSubtle))),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [footer]),
              ),
          ],
        ),
      ),
    );

    panel = TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.fast,
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, (1 - value) * -4), child: child),
      ),
      child: panel,
    );

    return CustomSingleChildLayout(
      delegate: _PopoverLayout(anchor: anchor, placement: widget.placement, gap: widget.offset),
      child: TapRegion(
        groupId: _tapGroup,
        onTapOutside: widget.closeOnOutsideTap ? (_) => _close() : null,
        child: CallbackShortcuts(
          bindings: {const SingleActivator(LogicalKeyboardKey.escape): _close},
          child: FocusScope(
            node: _panelScope,
            autofocus: true,
            child: Semantics(
              scopesRoute: true,
              namesRoute: true,
              explicitChildNodes: true,
              label: widget.title ?? widget.semanticLabel,
              child: Material(type: MaterialType.transparency, child: panel),
            ),
          ),
        ),
      ),
    );
  }
}

/// Places the panel under (or over) the anchor, aligned start/end/centre,
/// kept 8 px inside the screen, flipped when it doesn't fit.
class _PopoverLayout extends SingleChildLayoutDelegate {
  _PopoverLayout({required this.anchor, required this.placement, required this.gap});

  final Rect anchor;
  final AppPopoverPlacement placement;
  final double gap;

  static const double _margin = 8;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) => BoxConstraints.loose(
        Size(constraints.maxWidth - _margin * 2, constraints.maxHeight - _margin * 2),
      );

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final wantsBelow = switch (placement) {
      AppPopoverPlacement.bottomStart || AppPopoverPlacement.bottomEnd || AppPopoverPlacement.bottom => true,
      _ => false,
    };
    final fitsBelow = anchor.bottom + gap + childSize.height <= size.height - _margin;
    final fitsAbove = anchor.top - gap - childSize.height >= _margin;
    final below = wantsBelow ? (fitsBelow || !fitsAbove) : !(fitsAbove || !fitsBelow);

    double left = switch (placement) {
      AppPopoverPlacement.bottomStart || AppPopoverPlacement.topStart => anchor.left,
      AppPopoverPlacement.bottomEnd || AppPopoverPlacement.topEnd => anchor.right - childSize.width,
      AppPopoverPlacement.bottom || AppPopoverPlacement.top => anchor.center.dx - childSize.width / 2,
    };
    final maxLeft = size.width - childSize.width - _margin;
    left = left.clamp(_margin, maxLeft < _margin ? _margin : maxLeft).toDouble();
    final top = below ? anchor.bottom + gap : anchor.top - gap - childSize.height;
    return Offset(left, top);
  }

  @override
  bool shouldRelayout(_PopoverLayout old) =>
      old.anchor != anchor || old.placement != placement || old.gap != gap;
}
