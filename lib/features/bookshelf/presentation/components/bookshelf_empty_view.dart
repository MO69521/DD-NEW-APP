import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 书架清空后的空状态：插画 + 去书城分类的引导。
class BookshelfEmptyView extends StatelessWidget {
  const BookshelfEmptyView({super.key, this.onExploreTap});

  static const String _illustrationAsset =
      'assets/images/bookshelf/empty_bookshelf.png';
  static const String _message = '书架上还没有书哦～';
  static const String _actionLabel = '去逛逛';

  final VoidCallback? onExploreTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSizes.bookshelfEmptyTopPadding,
        bottom: AppSizes.bookshelfEmptyBottomPadding,
      ),
      child: Center(
        child: SizedBox(
          width: AppSizes.bookshelfEmptyBlockWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                _illustrationAsset,
                width: AppSizes.bookshelfEmptyIllustrationSize,
                height: AppSizes.bookshelfEmptyIllustrationSize,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: AppSizes.bookshelfEmptyIllustrationToTextGap,
              ),
              const AppText(
                _message,
                style: AppTextStyles.bookshelfEmptyMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.bookshelfEmptyTextToActionGap),
              AppButton(
                label: _actionLabel,
                variant: AppButtonVariant.accent,
                size: AppButtonSize.small,
                onPressed: onExploreTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
