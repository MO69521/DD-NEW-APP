import 'package:flutter/material.dart';

import '../../../../core/theme/app_layout.dart';
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

  static const String _avatarPlaceholderAsset =
      'assets/images/profile/avatar_placeholder.png';

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.backgroundDark),
        Opacity(
          opacity: AppSizes.profileHeroBackgroundImageOpacity,
          child: _ProfileHeroImageSource(
            avatarUrl: avatarUrl,
            placeholderAsset: _avatarPlaceholderAsset,
          ),
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

/// 头像 Hero 背景图源：网络失败或空 URL 时回退本地占位图（与 [AppNetworkAvatar] 一致）。
class _ProfileHeroImageSource extends StatelessWidget {
  const _ProfileHeroImageSource({
    required this.avatarUrl,
    required this.placeholderAsset,
  });

  final String avatarUrl;
  final String placeholderAsset;

  @override
  Widget build(BuildContext context) {
    final hasUrl = avatarUrl.isNotEmpty;

    if (!hasUrl) {
      return _assetImage();
    }

    return Image.network(
      avatarUrl,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => _assetImage(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _assetImage();
      },
    );
  }

  Widget _assetImage() {
    return Image.asset(
      placeholderAsset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) =>
          const ColoredBox(color: AppColors.backgroundDark),
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
            ProfileHeroBackground(avatarUrl: user.avatarUrl),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onProfileTap,
          behavior: HitTestBehavior.opaque,
          child: AppNetworkAvatar(
            imageUrl: user.avatarUrl,
            size: AppSizes.profileAvatarSize,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onProfileTap,
                behavior: HitTestBehavior.opaque,
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
            ],
          ),
        ),
      ],
    );
  }
}

/// L3 组件 — 我的页右上角消息入口（可固定在页面顶栏）。
class ProfileMessagesButton extends StatelessWidget {
  const ProfileMessagesButton({super.key, this.onTap});

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
            child: SizedBox.square(
              dimension: AppSizes.profileMessagesIconSize,
              child: AppIcon(
                assetPath: 'assets/icons/profile/settings_gear.svg',
                width: AppSizes.profileMessagesIconSize,
                height: AppSizes.profileMessagesIconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
