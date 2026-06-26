import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/glass_chip_button.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_text.dart';
import 'bookstore_search_bar.dart';
import '../../../../core/theme/app_theme_context.dart';

/// 书城顶栏（Figma 142:1953）：搜索框 + 分类按钮。
class BookstoreSearchHeader extends StatelessWidget {
  const BookstoreSearchHeader({
    super.key,
    required this.placeholder,
    this.onSearchTap,
    this.onCategoryTap,
  });

  final String placeholder;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCategoryTap;

  static const String categoryIconAsset = 'assets/icons/category.svg';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSizes.bookstoreHeaderVerticalInset,
        AppSpacing.sm,
        AppSizes.bookstoreHeaderVerticalInset,
      ),
      child: Row(
        children: [
          BookstoreSearchBar(
            placeholder: placeholder,
            onTap: onSearchTap,
          ),
          const SizedBox(width: AppSpacing.xs),
          GlassChipButton(
            onTap: onCategoryTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(
                  assetPath: categoryIconAsset,
                  width: AppSizes.iconSm,
                  height: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSpacing.xxs),
                AppText(
                  '分类',
                  style: AppTextStyles.searchPlaceholderDark.copyWith(
                    color: context.appColors.textPlaceholder,
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
