import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/dialog_close_button.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';

class WelfareRulesDialog extends StatelessWidget {
  const WelfareRulesDialog({super.key});

  static const List<_RuleSectionData> _sections = [
    _RuleSectionData(title: '星辰', body: '用于每日转换能量（汇率根据每日广告收入浮动）。可通过完成任务获得。'),
    _RuleSectionData(title: '能量', body: '用于解锁付费选项或进行商品购买。可通过充值或完成任务获得。'),
    _RuleSectionData(title: '祈愿星', body: '用于获取特定作品角色卡。可通过祈愿商城购买或活动奖励获得。'),
    _RuleSectionData(
      title: '爱心',
      body: '用于提升与角色之间的亲密度，同时角色获得的爱心数量将影响角色榜排名。可通过爱心礼包购买获得。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.dialogBackground,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.borderGlass),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    '规则说明',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textOnDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  for (final section in _sections) ...[
                    _RuleSection(section: section),
                    if (section != _sections.last)
                      const SizedBox(height: AppSpacing.md),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: '知道了',
                    variant: AppButtonVariant.accent,
                    isExpanded: true,
                    onPressed: AppRouter.pop,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.lg,
            right: AppSpacing.lg,
            child: DialogCloseButton(onTap: AppRouter.pop),
          ),
        ],
      ),
    );
  }
}

class _RuleSection extends StatelessWidget {
  const _RuleSection({required this.section});

  final _RuleSectionData section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '${section.title}：',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnDark,
            fontWeight: AppFontWeights.semibold,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        AppText(
          section.body,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnDarkMuted,
          ),
        ),
      ],
    );
  }
}

class _RuleSectionData {
  const _RuleSectionData({required this.title, required this.body});

  final String title;
  final String body;
}
