import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_button.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';

/// L2 — 分享底部弹层（遵循 §7.4 BottomSheet 规范：玻璃态 + 顶部圆角）。
///
/// 一行渠道（QQ好友 / QQ空间 / 微信 / 朋友圈 / 分享海报）+ 「取消」。
/// 点击渠道关闭弹层并回调 [onChannelTap]（携带渠道名）。
class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({super.key, this.onChannelTap});

  final ValueChanged<String>? onChannelTap;

  static Future<void> show(
    BuildContext context, {
    ValueChanged<String>? onChannelTap,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ShareBottomSheet(onChannelTap: onChannelTap),
    );
  }

  @override
  Widget build(BuildContext context) {
    final channels = <_ShareChannelData>[
      const _ShareChannelData(
        label: 'QQ好友',
        iconAsset: 'assets/icons/account_settings/qq.svg',
      ),
      const _ShareChannelData(label: 'QQ空间', iconData: Icons.star_rounded),
      const _ShareChannelData(
        label: '微信',
        iconAsset: 'assets/icons/account_settings/wechat.svg',
      ),
      const _ShareChannelData(label: '朋友圈', iconData: Icons.camera_alt_rounded),
      const _ShareChannelData(label: '分享海报', iconData: Icons.image_rounded),
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSizes.glassBlurSigma,
          sigmaY: AppSizes.glassBlurSigma,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.dialogBackground,
            border: Border(top: BorderSide(color: AppColors.borderGlass)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                AppText(
                  '好东西要一起看！立刻分享到',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textOnDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final channel in channels)
                        _ShareChannelTile(
                          data: channel,
                          onTap: () {
                            Navigator.of(context).pop();
                            onChannelTap?.call(channel.label);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: AppButton(
                    label: '取消',
                    variant: AppButtonVariant.secondary,
                    isExpanded: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShareChannelData {
  const _ShareChannelData({
    required this.label,
    this.iconAsset,
    this.iconData,
  });

  final String label;
  final String? iconAsset;
  final IconData? iconData;
}

class _ShareChannelTile extends StatelessWidget {
  const _ShareChannelTile({required this.data, this.onTap});

  final _ShareChannelData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.shareSheetChannelSize,
            height: AppSizes.shareSheetChannelSize,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceCard,
              shape: BoxShape.circle,
            ),
            child: data.iconAsset != null
                ? AppIcon(
                    assetPath: data.iconAsset!,
                    width: AppSizes.shareSheetChannelIconSize,
                    height: AppSizes.shareSheetChannelIconSize,
                    color: AppColors.textOnDark,
                  )
                : Icon(
                    data.iconData,
                    size: AppSizes.shareSheetChannelIconSize,
                    color: AppColors.textOnDark,
                  ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            data.label,
            style: AppTextStyles.captionMd.copyWith(
              color: AppColors.textOnDarkMuted,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
