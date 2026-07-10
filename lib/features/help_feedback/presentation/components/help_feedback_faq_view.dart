import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/help_feedback_page_content.dart';

/// L3 — 常见问题列表。
class HelpFeedbackFaqView extends StatelessWidget {
  const HelpFeedbackFaqView({
    super.key,
    required this.groups,
    this.onQuestionTap,
  });

  final List<HelpFeedbackFaqGroup> groups;
  final ValueChanged<String>? onQuestionTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        for (final group in groups) ...[
          // 分组标题独立于卡片之上，不被卡片块包裹。
          AppText(
            group.title,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textOnDarkMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _FaqQuestionsCard(group: group, onQuestionTap: onQuestionTap),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}

class _FaqQuestionsCard extends StatelessWidget {
  const _FaqQuestionsCard({required this.group, this.onQuestionTap});

  final HelpFeedbackFaqGroup group;
  final ValueChanged<String>? onQuestionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          for (var i = 0; i < group.questions.length; i++) ...[
            if (i > 0) const _FaqDivider(),
            _FaqQuestionRow(
              question: group.questions[i],
              onTap: onQuestionTap == null
                  ? null
                  : () => onQuestionTap!(group.questions[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _FaqQuestionRow extends StatelessWidget {
  const _FaqQuestionRow({required this.question, this.onTap});

  final String question;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSizes.listRowMinHeight,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  question,
                  style: AppTextStyles.bodyMediumDark,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const AppIcon(
                assetPath: 'assets/icons/arrow_right.svg',
                width: AppSpacing.sm,
                height: AppSpacing.sm,
                color: AppColors.textOnDarkPlaceholder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqDivider extends StatelessWidget {
  const _FaqDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: SizedBox(
        height: AppSizes.hairline,
        child: ColoredBox(color: AppColors.dividerOnDark),
      ),
    );
  }
}
