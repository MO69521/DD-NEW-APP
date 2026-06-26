import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_network_avatar.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../core/theme/app_colors.dart';

/// L3 组件 — 我的页 Hero 背景：头图（后端头像）+ 向下渐隐，可撑满父级高度。
class ProfileHeroBackground extends StatelessWidget {
  const ProfileHeroBackground({super.key, required this.avatarUrl});

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    final hasUrl = avatarUrl.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: AppColors.backgroundDark),
        if (hasUrl)
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: AppSizes.profileHeroHeight,
              width: double.infinity,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.profileHeroImageMaskOpaque,
                    AppColors.profileHeroImageMaskOpaque,
                    AppColors.profileHeroImageMaskSoft,
                    AppColors.profileHeroImageMaskTransparent,
                  ],
                  stops: AppSizes.profileHeroImageMaskStops,
                ).createShader(bounds),
                blendMode: BlendMode.dstIn,
                child: Opacity(
                  opacity: AppSizes.profileHeroBackgroundImageOpacity,
                  child: Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// L3 组件 — 我的页 Hero：用户信息 + 设置入口（背景由 [ProfileHeroBackground] 提供）。
class ProfileHeroHeader extends StatelessWidget {
  const ProfileHeroHeader({
    super.key,
    required this.user,
    this.onSettingsTap,
    this.onPartnersTap,
    this.showBackground = true,
  });

  final UserProfile user;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onPartnersTap;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.profileHeroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showBackground)
            ProfileHeroBackground(avatarUrl: user.avatarUrl),
          Positioned(
            top: MediaQuery.paddingOf(context).top +
                AppSizes.profileHeroSettingsTop,
            right: AppSpacing.md,
            child: _SettingsButton(onTap: onSettingsTap),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSizes.profileHeroUserInfoTop,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppNetworkAvatar(
                  imageUrl: user.avatarUrl,
                  size: AppSizes.profileAvatarSize,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        user.nickname,
                        style: AppTextStyles.profileNickname.copyWith(
                          color: AppColors.textOnDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppText(
                        'ID ${user.userId}',
                        style: AppTextStyles.profileUserId.copyWith(
                          color: AppColors.textOnDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PartnerAvatarsRow(
                        avatarUrls: user.partnerAvatarUrls,
                        onTap: onPartnersTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: AppSizes.profileSettingsButtonSize,
        height: AppSizes.profileSettingsButtonSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.overlayScrim,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Center(
            child: AppIcon(
              assetPath: 'assets/icons/profile/settings_gear.svg',
              width: AppSizes.welfareRechargeInfoIconSize,
              height: AppSizes.welfareRechargeInfoIconSize,
            ),
          ),
        ),
      ),
    );
  }
}

class _PartnerAvatarsRow extends StatelessWidget {
  const _PartnerAvatarsRow({
    required this.avatarUrls,
    this.onTap,
  });

  final List<String> avatarUrls;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {

    if (avatarUrls.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < avatarUrls.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSizes.profilePartnerAvatarGap),
            AppNetworkAvatar(
              imageUrl: avatarUrls[i],
              size: AppSizes.profilePartnerAvatarSize,
              borderWidth: 0,
            ),
          ],
          const SizedBox(width: AppSpacing.xxs),
          AppIcon(
            assetPath: 'assets/icons/arrow_right.svg',
            width: AppSpacing.sm,
            height: AppSpacing.sm,
            color: AppColors.textOnDark,
          ),
        ],
      ),
    );
  }
}
