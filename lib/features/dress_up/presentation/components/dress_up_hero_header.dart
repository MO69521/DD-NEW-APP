import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/widgets/app_network_avatar.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 我的装扮页头部：与「我的」页一致的 Hero 背景 + 用户信息，叠加返回顶栏。
class DressUpHeroHeader extends StatelessWidget {
  const DressUpHeroHeader({
    super.key,
    required this.avatarUrl,
    required this.nickname,
    required this.userId,
    required this.backgroundAsset,
    required this.statusBarHeight,
  });

  final String avatarUrl;
  final String nickname;
  final String userId;
  final String backgroundAsset;
  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    final height = AppLayout.figmaFrameHeight(
      context,
      AppSizes.profileHeroCompactHeight,
    );

    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: _Background(backgroundAsset: backgroundAsset)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppTopBar(
              statusBarHeight: statusBarHeight,
              title: '我的装扮',
              onBack: AppRouter.pop,
              chromeBlurEnabled: false,
              showScrim: true,
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top:
                AppLayout.figmaFrameTop(
                  context,
                  AppSizes.profileHeroUserInfoTop,
                ) +
                AppSpacing.md,
            child: _UserInfo(
              avatarUrl: avatarUrl,
              nickname: nickname,
              userId: userId,
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.backgroundAsset});

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

class _UserInfo extends StatelessWidget {
  const _UserInfo({
    required this.avatarUrl,
    required this.nickname,
    required this.userId,
  });

  final String avatarUrl;
  final String nickname;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppNetworkAvatar(imageUrl: avatarUrl, size: AppSizes.profileAvatarSize),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                nickname,
                style: AppTextStyles.profileNickname.copyWith(
                  color: AppColors.textOnDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                'ID $userId',
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
    );
  }
}
