import 'package:flutter/material.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_top_bar_icon_button.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_network_avatar.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../core/theme/app_colors.dart';

/// L3 组件 — 我的页 Hero 背景：独立素材图（非头像）+ 向下渐隐，可撑满父级高度。
///
/// [backgroundAsset] 为可替换素材图；后续不同主题/活动可传入不同素材。
class ProfileHeroBackground extends StatelessWidget {
  const ProfileHeroBackground({super.key, required this.backgroundAsset});

  final String backgroundAsset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.backgroundDark),
        Image.asset(
          backgroundAsset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              const ColoredBox(color: AppColors.backgroundDark),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundDark.withValues(alpha: 0),
                  AppColors.backgroundDark.withValues(alpha: 0),
                  AppColors.backgroundDark.withValues(alpha: 0.75),
                  AppColors.backgroundDark,
                ],
                stops: AppSizes.profileHeroImageMaskStops,
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
    this.onProfileTap,
    this.onMessagesTap,
    this.onPartnersTap,
    this.showBackground = true,
    this.showMessagesButton = true,
  });

  final UserProfile user;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMessagesTap;
  final VoidCallback? onPartnersTap;
  final bool showBackground;
  final bool showMessagesButton;

  @override
  Widget build(BuildContext context) {
    if (showBackground) {
      return SizedBox(
        height: AppLayout.figmaFrameHeight(context, AppSizes.profileHeroHeight),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ProfileHeroBackground(backgroundAsset: user.heroBackgroundAsset),
            _buildOverlay(context),
          ],
        ),
      );
    }

    return SizedBox(
      height: AppLayout.figmaFrameHeight(
        context,
        AppSizes.profileHeroCompactHeight,
      ),
      child: _buildOverlay(context),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (showMessagesButton)
          Positioned(
            top: AppLayout.figmaFrameTop(
              context,
              AppSizes.profileHeroSettingsTop,
            ),
            right: AppSpacing.md,
            child: ProfileMessagesButton(onTap: onMessagesTap),
          ),
        Positioned(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppLayout.figmaFrameTop(
            context,
            AppSizes.profileHeroUserInfoTop,
          ),
          child: _UserInfoBlock(user: user, onProfileTap: onProfileTap),
        ),
      ],
    );
  }
}

class _UserInfoBlock extends StatelessWidget {
  const _UserInfoBlock({required this.user, this.onProfileTap});

  final UserProfile user;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onProfileTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const AppIcon(
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

/// L3 组件 — 我的页右上角消息入口（可固定在页面顶栏）。
class ProfileMessagesButton extends StatelessWidget {
  const ProfileMessagesButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppTopBarIconButton(
      onTap: onTap,
      iconAsset: 'assets/icons/profile/settings_gear.svg',
      iconWidth: AppSizes.profileMessagesIconSize,
      iconHeight: AppSizes.profileMessagesIconSize,
    );
  }
}
