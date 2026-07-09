import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 互动场景右下主操作按钮（倾诉 + 对话，占位）。
class PartnerInteractionBottomActions extends StatelessWidget {
  const PartnerInteractionBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _CircleActionButton(
          size: AppSizes.partnerInteractionConfideActionSize,
          color: AppPartnerColors.interactionConfideButton,
          label: '倾诉',
          onTap: () {},
        ),
        SizedBox(height: AppSizes.partnerInteractionBottomActionGap),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _CircleActionButton(
              size: AppSizes.partnerInteractionChatActionSize,
              color: AppPartnerColors.interactionChatButton,
              label: '对话 Chat',
              labelStyle: AppTextStyles.partnerInteractionChatActionLabel,
              onTap: () {},
            ),
            Positioned(
              top: -AppSpacing.xs,
              right: -AppSpacing.xs,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: AppPartnerColors.interactionAiPlotBadgeBg,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: AppText(
                  'AI剧情',
                  style: AppTextStyles.partnerInteractionAiPlotBadge,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.size,
    required this.color,
    required this.label,
    this.labelStyle,
    this.onTap,
  });

  final double size;
  final Color color;
  final String label;
  final TextStyle? labelStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: AppText(
          label,
          style: labelStyle ?? AppTextStyles.partnerInteractionBottomActionLabel,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
