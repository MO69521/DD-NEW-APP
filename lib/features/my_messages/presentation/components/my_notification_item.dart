import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/my_notification.dart';

/// L3 组件 — 单条通知卡片（客服 / 系统）。
class MyNotificationItem extends StatelessWidget {
  const MyNotificationItem({super.key, required this.notification, this.onTap});

  final MyNotification notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isRead = notification.status == MyNotificationStatus.read;

    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.borderGlass,
          width: AppSizes.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppText(
                notification.senderName,
                style: AppTextStyles.bookDetailDiscussionAuthor,
                maxLines: 1,
              ),
              const SizedBox(width: AppSpacing.xxs),
              AppText(
                notification.actionLabel,
                style: AppTextStyles.bookDetailDiscussionAuthor,
                maxLines: 1,
              ),
              if (notification.status != MyNotificationStatus.read) ...[
                const SizedBox(width: AppSpacing.xs),
                _StatusBadge(status: notification.status),
              ],
              const Spacer(),
              const AppIcon(
                assetPath: 'assets/icons/arrow_right.svg',
                width: AppSpacing.sm,
                height: AppSpacing.sm,
                color: AppColors.textOnDarkPlaceholder,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            notification.content,
            style: AppTextStyles.bookCardLargeDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            notification.timeLabel,
            style: AppTextStyles.bookCardFooter,
            maxLines: 1,
          ),
        ],
      ),
    );

    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Opacity(opacity: isRead ? AppSizes.myMessagesReadOpacity : 1, child: card),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final MyNotificationStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == MyNotificationStatus.isNew) {
      return AppText(
        'NEW',
        style: AppTextStyles.captionSm.copyWith(
          color: AppColors.myMessagesNoticeBadge,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxsHalf,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: AppColors.myMessagesNoticeBadge,
          width: AppSizes.hairline,
        ),
      ),
      child: AppText(
        '未读',
        style: AppTextStyles.captionSm.copyWith(
          color: AppColors.myMessagesNoticeBadge,
        ),
      ),
    );
  }
}
