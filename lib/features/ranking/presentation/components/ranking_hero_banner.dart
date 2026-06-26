import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_text.dart';

/// 详情页头部 banner（Figma 690:8775）：插画背景 + 渐变蒙版 + 标题/副标题装饰。
class RankingHeroBanner extends StatelessWidget {
  const RankingHeroBanner({
    super.key,
    required this.title,
    required this.subtitle,
  });

  static const String _backgroundAsset = 'assets/images/ranking/hero_bg.png';

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _HeroBackground(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSizes.rankingHeroTitleBottomInset,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _TitleBlock(title: title, subtitle: subtitle),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            RankingHeroBanner._backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.rankingHeroScrimTop,
                  AppColors.gradientFadeStart,
                  AppColors.rankingHeroScrimMid,
                  AppColors.gradientFadeEnd,
                ],
                stops: AppSizes.rankingHeroScrimStops,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _Laurel(),
            const SizedBox(width: AppSizes.rankingHeroDecorationGap),
            AppText(title, style: AppTextStyles.rankingHeroTitle),
            const SizedBox(width: AppSizes.rankingHeroDecorationGap),
            const _Laurel(mirrored: true),
          ],
        ),
        const SizedBox(height: AppSizes.rankingHeroTitleToSubtitleGap),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _DecorationLine(),
            const SizedBox(width: AppSizes.rankingHeroDecorationGap),
            AppText(subtitle, style: AppTextStyles.rankingHeroSubtitle),
            const SizedBox(width: AppSizes.rankingHeroDecorationGap),
            const _DecorationLine(mirrored: true),
          ],
        ),
      ],
    );
  }
}

class _Laurel extends StatelessWidget {
  const _Laurel({this.mirrored = false});

  final bool mirrored;

  @override
  Widget build(BuildContext context) {
    const laurel = AppIcon(
      assetPath: 'assets/images/ranking/title_laurel.svg',
      width: AppSizes.rankingLaurelWidth,
      height: AppSizes.rankingLaurelHeight,
    );
    if (!mirrored) return laurel;
    return Transform.scale(scaleX: -1, child: laurel);
  }
}

class _DecorationLine extends StatelessWidget {
  const _DecorationLine({this.mirrored = false});

  final bool mirrored;

  @override
  Widget build(BuildContext context) {
    const line = AppIcon(
      assetPath: 'assets/images/ranking/subtitle_line.svg',
      width: AppSizes.rankingSubtitleLineWidth,
      height: AppSizes.rankingSubtitleLineHeight,
    );
    if (!mirrored) return line;
    return Transform.scale(scaleX: -1, child: line);
  }
}
