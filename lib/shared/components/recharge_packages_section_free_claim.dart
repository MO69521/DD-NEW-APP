part of 'recharge_packages_section.dart';

/// 充值区「免费领取」卡片：徽标 + 占位插画 + 可获得能量 + 领取按钮。
class _FreeClaimCard extends StatelessWidget {
  const _FreeClaimCard({required this.option, this.onTap});

  final EnergyFreeClaimOption option;
  final VoidCallback? onTap;

  bool get _isVip => option.kind == EnergyFreeClaimKind.vip;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        height: AppSizes.welfareRechargeCardHeight,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.borderGlass,
            width: AppSizes.hairline,
          ),
        ),
        clipBehavior: Clip.none,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: AppSizes.welfareRechargeIllustrationHeight,
                    width: AppSizes.welfareRechargeIllustrationWidth,
                    child: Center(
                      child: AppAssetImage(
                        assetPath: option.illustrationAsset,
                        height: AppSizes.welfareRechargeIllustrationHeight,
                        width: AppSizes.welfareRechargeIllustrationWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppText('可获得', style: AppTextStyles.captionSm),
                      const SizedBox(height: AppSpacing.xxs),
                      AppText(
                        '${option.energyAmount}',
                        style: AppTextStyles.welfareRechargeEnergyAmount,
                      ),
                    ],
                  ),
                  _FreeClaimCtaButton(
                    label: option.ctaLabel,
                    isVip: _isVip,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
            AppCornerBadge(
              label: option.badgeLabel,
              color: _isVip
                  ? AppWelfareColors.vipFreeClaimBadgeBackground
                  : AppWelfareColors.accentOrange,
              textColor: _isVip
                  ? AppWelfareColors.vipFreeClaimBadgeText
                  : AppColors.cornerBadgeText,
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeClaimCtaButton extends StatelessWidget {
  const _FreeClaimCtaButton({
    required this.label,
    this.isVip = false,
    this.onTap,
  });

  final String label;
  final bool isVip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 与价格按钮共用同款胶囊。VIP 领取按钮使用规范 VIP「vip」变体的粉紫渐变填充
    // （vipGradientStart→vipGradientEnd）+ 深粉字，无描边；其余保持暗色。
    // CTA 文案（如「VIP领取」）较长，窄卡内用 scaleDown 保证单行不折行。
    return _RechargePillButton(
      onTap: onTap,
      gradient: isVip
          ? const LinearGradient(
              colors: [
                AppWelfareColors.vipBannerGradientStart,
                AppWelfareColors.vipBannerGradientEnd,
              ],
            )
          : null,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: AppText(
          label,
          maxLines: 1,
          style: AppTextStyles.welfareRechargeClaimCta.copyWith(
            color: isVip ? AppWelfareColors.vipCtaText : AppColors.textOnDark,
          ),
        ),
      ),
    );
  }
}
