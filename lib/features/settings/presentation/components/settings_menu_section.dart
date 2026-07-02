import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/settings_menu_item.dart';

/// L3 组件 — 设置页菜单卡片容器。
class SettingsMenuSection extends StatelessWidget {
  const SettingsMenuSection({super.key, required this.items, this.onItemTap});

  final List<SettingsMenuItem> items;
  final ValueChanged<SettingsMenuAction>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(children: _buildRowsWithDividers()),
    );
  }

  List<Widget> _buildRowsWithDividers() {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      rows.add(
        SettingsMenuRow(
          item: item,
          onTap: onItemTap == null ? null : () => onItemTap!(item.action),
        ),
      );
      if (i < items.length - 1) {
        rows.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.borderGlass,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
          ),
        );
      }
    }
    return rows;
  }
}

/// L3 组件 — 设置页菜单行。
class SettingsMenuRow extends StatelessWidget {
  const SettingsMenuRow({super.key, required this.item, this.onTap});

  final SettingsMenuItem item;
  final VoidCallback? onTap;

  bool get _hasSubtitle => item.subtitle != null && item.subtitle!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.settingsMenuRowMinHeight,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        item.label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textOnDark,
                        ),
                      ),
                      if (_hasSubtitle) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        AppText(
                          item.subtitle!,
                          style: AppTextStyles.captionMdDarkMuted,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (item.trailingText != null) ...[
                  AppText(
                    item.trailingText!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textOnDarkMuted,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                ],
                const AppIcon(
                  assetPath: 'assets/icons/arrow_right.svg',
                  width: AppSpacing.sm,
                  height: AppSpacing.sm,
                  color: AppColors.textOnDarkPlaceholder,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
