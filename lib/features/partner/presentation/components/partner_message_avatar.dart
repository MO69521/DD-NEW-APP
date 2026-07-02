import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 消息列表头像 + 未读角标。
class PartnerMessageAvatar extends StatelessWidget {
  const PartnerMessageAvatar({
    super.key,
    required this.avatarAsset,
    required this.unreadCount,
  });

  final String avatarAsset;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.partnerMessageAvatarSize,
      height: AppSizes.partnerMessageAvatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: AppAssetImage(
              assetPath: avatarAsset,
              width: AppSizes.partnerMessageAvatarSize,
              height: AppSizes.partnerMessageAvatarSize,
              fit: BoxFit.cover,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: -AppSpacing.xxs,
              right: -AppSpacing.xxs,
              child: _UnreadBadge(count: unreadCount),
            ),
        ],
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';

    return Container(
      constraints: const BoxConstraints(
        minWidth: AppSizes.partnerMessageUnreadBadgeMinSize,
        minHeight: AppSizes.partnerMessageUnreadBadgeMinSize,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.partnerMessageUnreadBadgePaddingH,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppPartnerColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: AppPartnerColors.pageBackgroundBottom,
          width: AppSizes.hairline * 2,
        ),
      ),
      child: AppText(label, style: AppTextStyles.partnerNotificationBadge),
    );
  }
}
