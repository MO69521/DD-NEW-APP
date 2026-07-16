import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/profile_menu_item.dart';
import '../../../../core/theme/app_theme_context.dart';

/// L3 组件 — 我的页底部功能入口网格（Figma 208:7141）。
class ProfileShortcutGrid extends StatelessWidget {
  const ProfileShortcutGrid({super.key, required this.items, this.onItemTap});

  final List<ProfileMenuItem> items;
  final ValueChanged<ProfileMenuAction>? onItemTap;

  static const int _columns = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(children: _buildRows()),
    );
  }

  List<Widget> _buildRows() {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += _columns) {
      final rowItems = items.skip(i).take(_columns).toList();
      final isLastRow = i + _columns >= items.length;
      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: isLastRow ? 0 : AppSizes.profileShortcutRowGap,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var col = 0; col < _columns; col++)
                Expanded(
                  child: col < rowItems.length
                      ? _ShortcutItem(
                          item: rowItems[col],
                          onTap: onItemTap == null
                              ? null
                              : () => onItemTap!(rowItems[col].action),
                        )
                      : const SizedBox(
                          height: AppSizes.profileShortcutItemHeight,
                        ),
                ),
            ],
          ),
        ),
      );
    }
    return rows;
  }
}

class _ShortcutItem extends StatelessWidget {
  const _ShortcutItem({required this.item, this.onTap});

  final ProfileMenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        height: AppSizes.profileShortcutItemHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppAssetImage(
              assetPath: item.iconAsset,
              width: AppSizes.profileShortcutIconSize,
              height: AppSizes.profileShortcutIconSize,
              color: colors.textPrimary,
            ),
            const SizedBox(height: AppSizes.profileShortcutIconToLabelGap),
            AppText(
              item.label,
              style: AppTextStyles.profileShortcutLabel.copyWith(
                color: colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
