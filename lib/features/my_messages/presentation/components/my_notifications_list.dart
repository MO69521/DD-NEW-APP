import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/my_notification.dart';
import 'my_notification_item.dart';

/// L3 组件 — 通知列表（含「没有更多数据了」页脚）。
class MyNotificationsList extends StatelessWidget {
  const MyNotificationsList({super.key, required this.notifications});

  final List<MyNotification> notifications;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xl + bottomInset,
      ),
      itemCount: notifications.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, index) {
        if (index == notifications.length) {
          return const _ListFooter();
        }
        return MyNotificationItem(notification: notifications[index]);
      },
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: AppText(
          '没有更多数据了～',
          style: AppTextStyles.bookCardFooter,
          maxLines: 1,
        ),
      ),
    );
  }
}
