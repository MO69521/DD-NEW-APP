import 'package:flutter/material.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/partner_interaction_scene.dart';
import 'partner_interaction_bottom_actions.dart';
import 'partner_interaction_character_card.dart';
import 'partner_interaction_side_actions.dart';

/// L3 — 互动 Tab 单屏场景（全屏背景 + 悬浮控件）。
class PartnerInteractionScenePage extends StatelessWidget {
  const PartnerInteractionScenePage({
    super.key,
    required this.scene,
  });

  final PartnerInteractionScene scene;

  double _headerHeight(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    return AppSizes.partnerInteractionHeaderOverlayHeight(statusBarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = _headerHeight(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: AppAssetImage(
            assetPath: scene.backgroundAsset,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: AppSizes.partnerInteractionSceneBottomFadeHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppPartnerColors.pageBackgroundBottom,
                  AppPartnerColors.interactionSceneBottomFade,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.partnerInteractionOverlayHorizontalInset,
              headerHeight + AppSizes.partnerInteractionOverlayBelowHeaderGap,
              AppSizes.partnerInteractionOverlayHorizontalInset,
              AppSizes.partnerInteractionOverlayBottomInset,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: PartnerInteractionCharacterCard(scene: scene),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: PartnerInteractionSideActions(),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _ReviewButton(onTap: () {}),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: _PageIndicator(
                    current: scene.sceneIndex,
                    total: scene.totalScenes,
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: PartnerInteractionBottomActions(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewButton extends StatelessWidget {
  const _ReviewButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        height: AppSizes.partnerInteractionReviewButtonHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.partnerInteractionReviewButtonPaddingH,
        ),
        decoration: BoxDecoration(
          color: AppPartnerColors.interactionReviewButtonBg,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              size: AppSizes.partnerInteractionSideActionIconSize,
              color: AppPartnerColors.textPrimary,
            ),
            const SizedBox(width: AppSpacing.xxs),
            AppText('回顾', style: AppTextStyles.partnerInteractionReviewLabel),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.partnerInteractionPageIndicatorPaddingH,
        vertical: AppSizes.partnerInteractionPageIndicatorPaddingV,
      ),
      decoration: BoxDecoration(
        color: AppPartnerColors.interactionPageIndicatorBg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: AppText(
        '$current/$total',
        style: AppTextStyles.partnerInteractionPageIndicator,
      ),
    );
  }
}
