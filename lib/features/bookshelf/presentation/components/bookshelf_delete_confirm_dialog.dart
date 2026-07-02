import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/bookshelf_tab.dart';

/// L3 — 书架管理删除二次确认弹窗。
class BookshelfDeleteConfirmDialog extends StatelessWidget {
  const BookshelfDeleteConfirmDialog({
    super.key,
    required this.selectedTab,
    required this.selectedCount,
  });

  final BookshelfTab selectedTab;
  final int selectedCount;

  bool get _isHistory => selectedTab == BookshelfTab.history;

  String get _title {
    if (_isHistory) {
      return selectedCount > 1 ? '删除这 $selectedCount 条阅读历史？' : '删除这条阅读历史？';
    }
    return selectedCount > 1 ? '不再关注这 $selectedCount 本书籍？' : '不再关注该书籍？';
  }

  String get _description {
    if (_isHistory) {
      return '确认后将从阅读历史中移除，书籍仍会保留在书架中';
    }
    return '确认后将不再收到选中书籍的更新通知';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.dialogBackground,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                _title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textOnDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                _description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textOnDarkMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: '取消',
                      variant: AppButtonVariant.outline,
                      onPressed: () => AppRouter.pop(false),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: '确认',
                      variant: AppButtonVariant.accent,
                      onPressed: () => AppRouter.pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
