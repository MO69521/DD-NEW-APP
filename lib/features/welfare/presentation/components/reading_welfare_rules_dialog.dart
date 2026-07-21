import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_confirm_dialog.dart';
import '../../../../shared/widgets/app_text.dart';

/// 7 日阅读福利活动规则弹窗。
class ReadingWelfareRulesDialog extends StatelessWidget {
  const ReadingWelfareRulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      title: '7日福利活动说明',
      titleBodyGap: AppSpacing.lg,
      primaryLabel: '知道了',
      singlePrimary: true,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(
            '1.活动时间和规则：',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: AppFontWeights.semibold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            '活动每7日一轮，每轮活动期间总阅读时长达到4小时，可获得选项限免卡。\n'
            '每轮活动将重新累计阅读时长，上一轮时长不计入本轮活动中。',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: AppLineHeights.loose,
            ),
          ),
        ],
      ),
    );
  }
}
