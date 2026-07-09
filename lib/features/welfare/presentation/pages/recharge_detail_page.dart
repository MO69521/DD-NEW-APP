import 'package:flutter/material.dart';

import '../../../../core/domain/entities/commerce_entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 页面 — 充值套餐详情（容器转换动效的展开目标，示例页）。
///
/// 由 [AdvancedTransitionWrapper] 的 `openBuilder` 注入 [onClose]，
/// 关闭时触发缩回动画，无需在页面内直接调用 Navigator。
class RechargeDetailPage extends StatelessWidget {
  const RechargeDetailPage({
    super.key,
    required this.package,
    required this.onClose,
  });

  final RechargePackage package;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppSizes.welfareHeaderHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _CloseButton(onTap: onClose),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: AppAssetImage(
                  assetPath: package.illustrationAsset,
                  height: AppSizes.welfareRechargeIllustrationHeight * 3,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: AppText(
                  '${package.energyAmount} 能量',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textOnDark,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Center(
                child: AppText(
                  '原价 ${package.originalAmount} 能量',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnDarkMuted,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: AppColors.textOnDarkMuted,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _DetailRow(label: '套餐编号', value: package.id),
              _DetailRow(label: '到账能量', value: '${package.energyAmount}'),
              _DetailRow(label: '限时优惠', value: package.badgeLabel ?? '常规套餐'),
              const Spacer(),
              AppButton(
                label: '¥ ${package.priceYuan} 立即充值',
                variant: AppButtonVariant.accent,
                isExpanded: true,
                onPressed: onClose,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.xs),
        child: Icon(
          Icons.close_rounded,
          color: AppColors.textOnDark,
          size: AppSizes.welfareTaskActionIconSize,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textOnDarkMuted,
              ),
            ),
            AppText(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textOnDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
