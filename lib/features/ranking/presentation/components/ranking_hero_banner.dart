import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_text.dart';

/// 详情页头部 banner（Figma 1297:783）：固定头图 + 标题装饰。
class RankingHeroBanner extends StatelessWidget {
  const RankingHeroBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageOpacity = AppColors.rankingHeroImageLayerOpacity,
  });

  /// 榜单头图固定资源（Figma 1297:826）。
  static const String heroBackgroundAsset = 'assets/images/ranking/hero_bg.png';

  final String title;
  final String subtitle;

  /// 插画层不透明度（Figma 1297:826 `opacity-50`）。
  final double imageOpacity;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppSizes.rankingHeroAspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final heroWidth = constraints.maxWidth;
          final titleBlockHeight = AppLayout.rankingScaledDesignY(
            heroWidth,
            AppSizes.rankingHeroTitleBlockHeight,
          );
          final titleTop = AppLayout.rankingScaledDesignY(
            heroWidth,
            AppSizes.rankingHeroTitleBlockTop,
          );

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              const ColoredBox(color: AppColors.backgroundDark),
              Positioned.fill(
                child: _FigmaMaskedHeroImage(imageOpacity: imageOpacity),
              ),
              Positioned(
                top: titleTop,
                left: 0,
                right: 0,
                height: titleBlockHeight,
                child: Center(
                  child: _TitleBlock(title: title, subtitle: subtitle),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FigmaMaskedHeroImage extends StatelessWidget {
  const _FigmaMaskedHeroImage({required this.imageOpacity});

  final double imageOpacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        Opacity(
          opacity: imageOpacity,
          child: Image.asset(
            RankingHeroBanner.heroBackgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) => const ColoredBox(
              color: AppColors.backgroundDark,
            ),
          ),
        ),
        const Positioned.fill(child: _HeroImageScrim()),
      ],
    );
  }
}

/// 头图底部渐隐：只处理与背景的过渡，不再压暗整张图。
class _HeroImageScrim extends StatelessWidget {
  const _HeroImageScrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.gradientFadeStart,
            AppColors.gradientFadeMid,
            AppColors.backgroundDark,
          ],
          stops: AppSizes.rankingHeroImageScrimStops,
        ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final blockWidth = constraints.maxWidth;
        final mainHeight = AppLayout.rankingScaledDesignY(
          blockWidth,
          AppSizes.rankingHeroTitleMainHeight,
        );
        final subtitleTop = AppLayout.rankingScaledDesignY(
          blockWidth,
          AppSizes.rankingHeroSubtitleTop,
        );

        return SizedBox(
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: mainHeight,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _Laurel(),
                      SizedBox(
                        width: AppLayout.rankingScaledDesignX(
                          blockWidth,
                          AppSizes.rankingHeroDecorationGap,
                        ),
                      ),
                      AppText(title, style: AppTextStyles.rankingHeroTitle),
                      SizedBox(
                        width: AppLayout.rankingScaledDesignX(
                          blockWidth,
                          AppSizes.rankingHeroDecorationGap,
                        ),
                      ),
                      const _Laurel(mirrored: true),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: subtitleTop,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _DecorationLine(),
                    SizedBox(
                      width: AppLayout.rankingScaledDesignX(
                        blockWidth,
                        AppSizes.rankingHeroDecorationGap,
                      ),
                    ),
                    AppText(subtitle, style: AppTextStyles.rankingHeroSubtitle),
                    SizedBox(
                      width: AppLayout.rankingScaledDesignX(
                        blockWidth,
                        AppSizes.rankingHeroDecorationGap,
                      ),
                    ),
                    const _DecorationLine(mirrored: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
