import 'package:flutter/material.dart';

import '../../core/constants/currency_config.dart';
import '../../core/domain/entities/commerce_entities.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_welfare_colors.dart';
import 'sweep_highlight_overlay.dart';
import '../widgets/app_asset_image.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';

/// L2 组件 — VIP 开通引导横幅（Figma 296:5304 / 386:2170）。
///
/// 福利页与我的页复用；仅渲染传入数据，不含业务逻辑。
class VipPromoBanner extends StatefulWidget {
  const VipPromoBanner({
    super.key,
    required this.monthlyEnergy,
    required this.priceYuan,
    this.onTap,
  });

  final int monthlyEnergy;
  final double priceYuan;
  final VoidCallback? onTap;

  @override
  State<VipPromoBanner> createState() => _VipPromoBannerState();
}

class _VipPromoBannerState extends State<VipPromoBanner>
    with SingleTickerProviderStateMixin {
  static const String _vipBadgeAsset = 'assets/icons/welfare/vip_badge.png';

  late final AnimationController _breathController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaBreath,
    )..repeat(reverse: true);
    _breathScale =
        Tween<double>(
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

  String get _priceLabel {
    final wholePrice = widget.priceYuan.truncateToDouble();
    return widget.priceYuan == wholePrice
        ? wholePrice.toInt().toString()
        : widget.priceYuan.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: widget.onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.welfareVipBanner),
        child: SizedBox(
          height: AppSizes.welfareVipBannerHeight,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppWelfareColors.vipBannerGradientStart,
                        AppWelfareColors.vipBannerGradientEnd,
                      ],
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppAssetImage(
                              assetPath: _vipBadgeAsset,
                              width: AppSizes.welfareVipBadgeSize,
                              height: AppSizes.welfareVipBadgeSize,
                            ),
                            const SizedBox(
                              width: AppSizes.welfareVipBadgeTextGap,
                            ),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: AppText(
                                      '开通VIP立即获得 ${widget.monthlyEnergy}',
                                      style: AppTextStyles.welfareVipBannerLabel
                                          .copyWith(
                                            color:
                                                AppWelfareColors.vipBannerText,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppSizes.welfareVipTextIconGap,
                                  ),
                                  AppAssetImage(
                                    assetPath: CurrencyConfig.iconAsset(
                                      CurrencyType.energy,
                                    ),
                                    width: AppSizes.welfareCurrencyIconSize,
                                    height: AppSizes.welfareCurrencyIconSize,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ScaleTransition(
                        scale: _breathScale,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppRadius.welfareVipCta,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppWelfareColors.vipCtaGradientStart,
                                  AppWelfareColors.vipCtaGradientEnd,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.welfareVipCta,
                              ),
                              border: Border.all(
                                color: AppWelfareColors.vipCtaBorder,
                                width: AppSizes.welfareVipCtaBorderWidth,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Positioned.fill(
                                  child: SweepHighlightOverlay(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.welfareVipCtaPaddingHorizontal,
                                    vertical:
                                        AppSizes.welfareVipCtaPaddingVertical,
                                  ),
                                  child: AppText(
                                    '¥$_priceLabel 开通',
                                    style: AppTextStyles.welfareVipCtaLabel
                                        .copyWith(
                                          color: AppWelfareColors.vipCtaText,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
