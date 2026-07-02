import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 账号设置页分组：区块标题 + 卡片容器。
class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: AppText(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textOnDarkMuted,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            children: _buildRowsWithDividers(children),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRowsWithDividers(List<Widget> rows) {
    if (rows.isEmpty) return const [];

    final result = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      result.add(rows[i]);
      if (i < rows.length - 1) {
        result.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.borderGlass,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
          ),
        );
      }
    }
    return result;
  }
}
