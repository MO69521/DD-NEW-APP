import 'package:flutter/material.dart';

import '../../core/constants/currency_config.dart';
import '../../core/domain/entities/commerce_entities.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_asset_image.dart';
import '../widgets/app_text.dart';
import '../../core/theme/app_welfare_colors.dart';

/// L2 组件 — VIP 开通引导横幅（Figma 296:5304 / 386:2170）。
///
/// 福利页与我的页复用；仅渲染传入数据，不含业务逻辑。
class VipPromoBanner extends StatelessWidget {
  const VipPromoBanner({
    super.key,
    required this.monthlyEnergy,
    required this.priceYuan,
    this.onTap,
  });

  final int monthlyEnergy;
  final double priceYuan;
  final VoidCallback? onTap;

  static const String _vipBadgeAsset = 'assets/icons/welfare/vip_badge.png';

  String get _priceLabel {
    final wholePrice = priceYuan.truncateToDouble();
    return priceYuan == wholePrice
        ? wholePrice.toInt().toString()
        : priceYuan.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.welfareVipBanner),
        child: SizedBox(
          height: AppSizes.welfareVipBannerHeight,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              DecoratedBox(
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
                                      '开通VIP立即获得 $monthlyEnergy',
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
                      DecoratedBox(
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.welfareVipCtaPaddingHorizontal,
                            vertical: AppSizes.welfareVipCtaPaddingVertical,
                          ),
                          child: AppText(
                            '¥$_priceLabel 开通',
                            style: AppTextStyles.welfareVipCtaLabel.copyWith(
                              color: AppWelfareColors.vipCtaText,
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
