import 'package:flutter/material.dart';

import '../../../../core/theme/app_shared_assets.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';

/// L3 — 书架清空后的空状态：插画 + 去书城分类的引导。
class BookshelfEmptyView extends StatelessWidget {
  const BookshelfEmptyView({super.key, this.onExploreTap});

  static const String _illustrationAsset = AppSharedAssets.emptyBookshelf;
  static const String _message = '书架上还没有书哦～';
  static const String _actionLabel = '去逛逛';

  final VoidCallback? onExploreTap;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: _message,
      titleStyle: AppTextStyles.bookshelfEmptyMessage,
      contentWidth: AppSizes.bookshelfEmptyBlockWidth,
      padding: const EdgeInsets.only(
        top: AppSizes.bookshelfEmptyTopPadding,
        bottom: AppSizes.bookshelfEmptyBottomPadding,
      ),
      illustrationGap: AppSizes.bookshelfEmptyIllustrationToTextGap,
      actionGap: AppSizes.bookshelfEmptyTextToActionGap,
      illustration: Image.asset(
        _illustrationAsset,
        width: AppSizes.bookshelfEmptyIllustrationSize,
        height: AppSizes.bookshelfEmptyIllustrationSize,
        fit: BoxFit.contain,
      ),
      action: AppButton(
        label: _actionLabel,
        variant: AppButtonVariant.accent,
        size: AppButtonSize.small,
        onPressed: onExploreTap,
      ),
    );
  }
}
