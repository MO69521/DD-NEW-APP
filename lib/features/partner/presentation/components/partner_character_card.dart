import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/partner_character.dart';
import '../../domain/entities/partner_collection_status.dart';
import 'partner_trait_tag.dart';

/// L3 — 探索页角色卡片。
class PartnerCharacterCard extends StatefulWidget {
  const PartnerCharacterCard({
    super.key,
    required this.character,
    this.onTap,
  });

  final PartnerCharacter character;
  final VoidCallback? onTap;

  @override
  State<PartnerCharacterCard> createState() => _PartnerCharacterCardState();
}

class _PartnerCharacterCardState extends State<PartnerCharacterCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final collected =
        character.collectionStatus == PartnerCollectionStatus.collected;

    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _pressed = false),
      onTapCancel: widget.onTap == null ? null : () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppPartnerColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.partnerCharacterCard),
          border: Border.all(
            color: AppPartnerColors.borderGlass,
            width: AppSizes.hairline,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CoverSection(
                  eraTitle: character.eraTitle,
                  portraitAsset: character.coverAsset,
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.partnerCharacterCardPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        character.name,
                        style: AppTextStyles.partnerCharacterName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: AppSizes.partnerCharacterNameToQuoteGap,
                      ),
                      AppText(
                        character.quote,
                        style: AppTextStyles.partnerCharacterQuote,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: AppSizes.partnerCharacterQuoteToSubtitleGap,
                      ),
                      AppText(
                        character.sourceTitle,
                        style: AppTextStyles.partnerCharacterSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: AppSizes.partnerCharacterSubtitleToFooterGap,
                      ),
                      _CharacterCardFooter(
                        traitTags: character.traitTags,
                        followerCount: character.followerCount,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: AppSpacing.xs,
              right: AppSpacing.xs,
              child: _CollectionBadge(
                label: character.collectionStatus.label,
                collected: collected,
              ),
            ),
            if (_pressed)
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppPartnerColors.cardPressedOverlay,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CharacterCardFooter extends StatelessWidget {
  const _CharacterCardFooter({
    required this.traitTags,
    required this.followerCount,
  });

  final List<String> traitTags;
  final String followerCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.partnerTraitTagHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRect(
              child: Row(
                children: [
                  for (var i = 0; i < traitTags.length; i++) ...[
                    if (i > 0)
                      const SizedBox(width: AppSizes.partnerTraitTagSpacing),
                    PartnerTraitTag(label: traitTags[i]),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          AppText(
            followerCount,
            style: AppTextStyles.partnerFollowerCount,
          ),
        ],
      ),
    );
  }
}

class _CoverSection extends StatelessWidget {
  const _CoverSection({
    required this.eraTitle,
    required this.portraitAsset,
  });

  final String eraTitle;
  final String portraitAsset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width / AppSizes.partnerCharacterCoverAspectRatio;

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: AppPartnerColors.surfaceCard),
              AppAssetImage(
                assetPath: portraitAsset,
                fit: BoxFit.cover,
                width: width,
                height: height,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppPartnerColors.overlayScrim.withValues(alpha: 0),
                      AppPartnerColors.coverTitleShadow,
                    ],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: AppText(
                  eraTitle,
                  style: AppTextStyles.partnerCoverTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CollectionBadge extends StatelessWidget {
  const _CollectionBadge({
    required this.label,
    required this.collected,
  });

  final String label;
  final bool collected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSizes.partnerCharacterBadgeMinHeight,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.partnerCharacterBadgePaddingH,
        vertical: AppSizes.partnerCharacterBadgePaddingV,
      ),
      decoration: BoxDecoration(
        color: collected
            ? AppPartnerColors.primary
            : AppPartnerColors.badgeUncollectedBg,
        borderRadius: BorderRadius.circular(AppRadius.partnerCollectionBadge),
      ),
      child: AppText(
        label,
        style: collected
            ? AppTextStyles.partnerCollectionBadge
            : AppTextStyles.partnerCollectionBadgeMuted,
      ),
    );
  }
}
