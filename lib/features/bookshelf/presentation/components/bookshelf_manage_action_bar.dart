import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_selection_mark.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// 书架管理态底部操作栏，覆盖主 Tab 导航。
class BookshelfManageActionBar extends StatelessWidget {
  const BookshelfManageActionBar({
    super.key,
    required this.selectedCount,
    required this.isAllSelected,
    required this.onSelectAllTap,
    required this.onDeleteTap,
  });

  final int selectedCount;
  final bool isAllSelected;
  final VoidCallback onSelectAllTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final canDelete = selectedCount > 0;
    return Align(
      alignment: Alignment.bottomCenter,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.backgroundDark),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppBottomNav.barHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  AppPressable(
                    onTap: onSelectAllTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SelectAllMark(isSelected: isAllSelected),
                        const SizedBox(width: AppSpacing.xs),
                        AppText(
                          '全选',
                          style: AppTextStyles.bodyMediumDark.copyWith(
                            color: AppColors.textOnDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  AppButton(
                    label: canDelete ? '删除($selectedCount)' : '删除',
                    variant: canDelete
                        ? AppButtonVariant.accent
                        : AppButtonVariant.secondary,
                    size: AppButtonSize.small,
                    onPressed: canDelete ? onDeleteTap : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectAllMark extends StatelessWidget {
  const _SelectAllMark({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AppSelectionMark(isSelected: isSelected);
  }
}
