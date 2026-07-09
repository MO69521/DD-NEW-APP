import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/book_detail.dart';
import 'book_detail_character_card.dart';
import 'book_detail_character_help_dialog.dart';

/// 角色介绍区块：标题 + 横滑角色卡（Figma 579:26105）。
class BookDetailCharacterSection extends StatelessWidget {
  const BookDetailCharacterSection({
    super.key,
    required this.characters,
    this.onCharacterFavTap,
  });

  final List<BookCharacter> characters;
  final ValueChanged<String>? onCharacterFavTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Header(),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < characters.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.md),
                BookDetailCharacterCard(
                  character: characters[i],
                  onFavTap: onCharacterFavTap == null
                      ? null
                      : () => onCharacterFavTap!(characters[i].id),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppText('角色介绍', style: AppTextStyles.bookDetailSectionTitle),
        const SizedBox(width: AppSpacing.xxs),
        AppPressable(
          onTap: () {
            showAppBlurredDialog<void>(
              context: context,
              builder: (_) => const BookDetailCharacterHelpDialog(),
            );
          },
          child: const Icon(
            Icons.info_outline,
            size: AppSizes.bookDetailBottomIconSize,
            color: AppColors.textOnDarkMuted,
          ),
        ),
        const Spacer(),
        const AppText('滑动查看更多', style: AppTextStyles.bookDetailSectionHint),
        const SizedBox(width: AppSpacing.xxs),
        const AppIcon(
          assetPath: 'assets/icons/arrow_right.svg',
          width: AppSizes.bookDetailSectionHintIconSize,
          height: AppSizes.bookDetailSectionHintIconSize,
          color: AppColors.textOnDarkMuted,
        ),
      ],
    );
  }
}
