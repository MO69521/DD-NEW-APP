import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/my_message.dart';
import 'my_message_item.dart';

/// L3 组件 — 互动消息列表（回复 / 获赞）。
class MyMessagesList extends StatelessWidget {
  const MyMessagesList({super.key, required this.messages});

  final List<MyMessage> messages;

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
      itemCount: messages.length,
      separatorBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Divider(
          height: AppSizes.hairline,
          thickness: AppSizes.hairline,
          color: AppColors.dividerOnDark,
        ),
      ),
      itemBuilder: (_, index) => MyMessageItem(message: messages[index]),
    );
  }
}
