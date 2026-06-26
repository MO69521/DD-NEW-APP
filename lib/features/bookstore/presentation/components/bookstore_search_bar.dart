import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/glass_chip_button.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../core/theme/app_colors.dart';

/// 书城搜索框（Figma 142:1954）：玻璃态胶囊 + 搜索图标 + 占位文案。
class BookstoreSearchBar extends StatelessWidget {
  const BookstoreSearchBar({
    super.key,
    required this.placeholder,
    this.onTap,
  });

  final String placeholder;
  final VoidCallback? onTap;

  static const String searchIconAsset = 'assets/icons/search.svg';

  @override
  Widget build(BuildContext context) {
    return GlassChipButton(
      expanded: true,
      onTap: onTap,
      child: Row(
        children: [
          AppIcon(
            assetPath: searchIconAsset,
            width: AppSizes.iconSm,
            height: AppSizes.iconSm,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: AppText(
              placeholder,
              style: AppTextStyles.searchPlaceholderDark.copyWith(
                color: AppColors.textOnDarkPlaceholder,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
