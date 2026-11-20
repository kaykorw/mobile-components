// AppAvatar and AppAvatarLabel: Flutter counterparts of React <Avatar> and <AvatarLabel>.
import 'package:flutter/material.dart';

import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// 24, 28, 36, 48 px. Same names as React.
enum AppAvatarSize { small, medium, large, xlarge }

enum AppAvatarShape { circle, square }

/// "Nineth sub-account" -> "NS". Same rule as React getInitials().
String appInitials(String name, {int max = 2}) {
  return name
      .trim()
      .split(RegExp(r'[\s\-_.]+'))
      .where((word) => word.isNotEmpty)
      .take(max)
      .map((word) => word[0].toUpperCase())
      .join();
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = AppAvatarSize.medium,
    this.shape = AppAvatarShape.circle,
    this.excludeFromSemantics = false,
  });

  /// Person or account name: used for the initials and the accessible name.
  final String name;

  /// Photo URL. Falls back to initials if it fails to load.
  final String? imageUrl;
  final AppAvatarSize size;
  final AppAvatarShape shape;
  final bool excludeFromSemantics;

  double get _dimension => switch (size) {
        AppAvatarSize.small => 24,
        AppAvatarSize.medium => 28,
        AppAvatarSize.large => 36,
        AppAvatarSize.xlarge => 48,
      };

  double get _fontSize => switch (size) {
        AppAvatarSize.small => 10,
        AppAvatarSize.medium => 11,
        AppAvatarSize.large => AppType.sm,
        AppAvatarSize.xlarge => AppType.lg,
      };

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final initials = Center(
      child: Text(
        appInitials(name),
        style: AppType.style(_fontSize, weight: FontWeight.w600, color: t.textMuted, height: 1),
      ),
    );
    final url = imageUrl;
    final avatar = Container(
      width: _dimension,
      height: _dimension,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.surfaceSunken,
        shape: shape == AppAvatarShape.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shape == AppAvatarShape.square ? AppRadius.all(AppRadius.md) : null,
      ),
      child: url == null
          ? initials
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => initials,
            ),
    );
    if (excludeFromSemantics) return ExcludeSemantics(child: avatar);
    return Semantics(label: name, image: true, excludeSemantics: true, child: avatar);
  }
}

/// Avatar with a title and description, as in the Name column of the Accounts table.
class AppAvatarLabel extends StatelessWidget {
  const AppAvatarLabel({
    super.key,
    required this.title,
    this.description,
    this.extra,
    this.imageUrl,
    this.avatarSize = AppAvatarSize.medium,
    this.hideAvatar = false,
  });

  /// Main line, e.g. an account name. Also used for the avatar initials.
  final String title;

  /// Second line, e.g. the account type ("INDIVIDUAL").
  final String? description;

  /// Extra widget under the text, e.g. a "Parent" badge.
  final Widget? extra;
  final String? imageUrl;
  final AppAvatarSize avatarSize;
  final bool hideAvatar;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hideAvatar) ...[
          AppAvatar(name: title, imageUrl: imageUrl, size: avatarSize, excludeFromSemantics: true),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.style(AppType.md, weight: FontWeight.w500, color: t.text),
              ),
              if (description case final text?) ...[
                const SizedBox(height: 2),
                Text(text, style: AppType.style(AppType.xs, color: t.textSubtle)),
              ],
              if (extra case final widget?) ...[const SizedBox(height: 4), widget],
            ],
          ),
        ),
      ],
    );
  }
}
