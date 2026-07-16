import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 自动续费服务声明区：标题 + 多段说明。
class MembershipAutoRenewStatement extends StatelessWidget {
  const MembershipAutoRenewStatement({
    super.key,
    required this.title,
    required this.paragraphs,
  });

  final String title;
  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.membershipCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: AppText(title, style: AppTextStyles.membershipSectionTitle),
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < paragraphs.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            AppText(
              paragraphs[i],
              style: AppTextStyles.membershipStatementBody,
            ),
          ],
        ],
      ),
    );
  }
}
