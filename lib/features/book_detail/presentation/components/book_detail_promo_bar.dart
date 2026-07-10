import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/sweep_highlight_overlay.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// 悬浮促销条（Figma 1598:4319）：浮在底部操作栏上方的可关闭推广条。
///
/// 仅渲染 + 触发回调，可见/关闭状态由 application 层持有。
class BookDetailPromoBar extends StatelessWidget {
  const BookDetailPromoBar({
    super.key,
    required this.title,
    this.subtitle = '提示词已复制，进APP粘贴',
    this.rewardLabel = '+20',
    this.onClaim,
    this.onClose,
  });

  static const String _energyIconAsset = 'assets/icons/welfare/energy.svg';
  static const String _rewardTagAsset =
      'assets/icons/book_detail/promo_reward_tag.svg';

  final String title;
  final String subtitle;
  final String rewardLabel;
  final VoidCallback? onClaim;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSizes.bookDetailPromoRewardTagTopOverhang,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _card(),
          Positioned(
            left: AppSizes.bookDetailPromoRewardTagLeft,
            top: -AppSizes.bookDetailPromoRewardTagTopOverhang,
            child: _rewardTag(),
          ),
          Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.xs,
            child: AppPressable(
              onTap: onClose,
              child: Icon(
                Icons.close_rounded,
                size: AppSizes.bookDetailPromoCloseSize,
                color: AppColors.bookDetailPromoCloseIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.bookDetailPromoGradientStart,
            AppColors.bookDetailPromoGradientMid,
            AppColors.bookDetailPromoGradientEnd,
          ],
          stops: [0.109, 0.459, 0.994],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.lg,
        top: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                AppAssetImage(
                  assetPath: _energyIconAsset,
                  width: AppSizes.bookDetailPromoIconSize,
                  height: AppSizes.bookDetailPromoIconSize,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        style: AppTextStyles.bookDetailPromoTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        subtitle,
                        style: AppTextStyles.bookDetailPromoSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _ClaimButton(onTap: onClaim),
        ],
      ),
    );
  }

  Widget _rewardTag() {
    return SizedBox(
      width: AppSizes.bookDetailPromoRewardTagWidth,
      height: AppSizes.bookDetailPromoRewardTagHeight,
      child: Stack(
        children: [
          const Positioned.fill(
            child: AppAssetImage(
              assetPath: _rewardTagAsset,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: AppSizes.bookDetailPromoRewardTextTop,
            child: Center(
              child: AppText(
                rewardLabel,
                style: AppTextStyles.bookDetailPromoReward,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 「立即领取」按钮：切图底 + 循环扫光 + 呼吸缩放（复用统一 CTA 动效档位）。
class _ClaimButton extends StatefulWidget {
  const _ClaimButton({this.onTap});

  static const String _asset =
      'assets/images/book_detail/promo_claim_button.png';

  final VoidCallback? onTap;

  @override
  State<_ClaimButton> createState() => _ClaimButtonState();
}

class _ClaimButtonState extends State<_ClaimButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaBreath,
    )..repeat(reverse: true);
    _breathScale = Tween<double>(
      begin: AppSizes.membershipCtaBreathScaleMin,
      end: AppSizes.membershipCtaBreathScaleMax,
    ).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _breathScale,
        alignment: Alignment.center,
        child: SizedBox(
          width: AppSizes.bookDetailPromoClaimMinWidth,
          height: AppSizes.bookDetailPromoClaimHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: const Stack(
              fit: StackFit.expand,
              children: [
                AppAssetImage(
                  assetPath: _ClaimButton._asset,
                  fit: BoxFit.fill,
                ),
                SweepHighlightOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
