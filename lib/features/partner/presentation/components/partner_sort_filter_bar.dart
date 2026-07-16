import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/partner_sort_mode.dart';

/// L3 — 热门 / 新作排序与筛选入口。
class PartnerSortFilterBar extends StatelessWidget {
  const PartnerSortFilterBar({
    super.key,
    required this.sortMode,
    this.onSortModeChanged,
    this.onFilterTap,
  });

  final PartnerSortMode sortMode;
  final ValueChanged<PartnerSortMode>? onSortModeChanged;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.partnerSortBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            _SortOption(
              label: PartnerSortMode.hot.label,
              icon: Icons.local_fire_department_rounded,
              showNewBadge: false,
              isSelected: sortMode == PartnerSortMode.hot,
              onTap: onSortModeChanged == null
                  ? null
                  : () => onSortModeChanged!(PartnerSortMode.hot),
            ),
            const SizedBox(width: AppSpacing.md),
            _SortOption(
              label: PartnerSortMode.newest.label,
              showNewBadge: true,
              isSelected: sortMode == PartnerSortMode.newest,
              onTap: onSortModeChanged == null
                  ? null
                  : () => onSortModeChanged!(PartnerSortMode.newest),
            ),
            const Spacer(),
            _FilterButton(onTap: onFilterTap),
          ],
        ),
      ),
    );
  }
}

class _SortOption extends StatefulWidget {
  const _SortOption({
    required this.label,
    this.icon,
    required this.showNewBadge,
    required this.isSelected,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool showNewBadge;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  State<_SortOption> createState() => _SortOptionState();
}

class _SortOptionState extends State<_SortOption> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected
        ? AppPartnerColors.primary
        : (_pressed
              ? AppPartnerColors.textPrimary
              : AppPartnerColors.textSecondary);
    final textStyle = widget.isSelected
        ? AppTextStyles.partnerSortActive
        : AppTextStyles.partnerSortInactive;

    return GestureDetector(
      onTapDown: widget.onTap == null
          ? null
          : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) => setState(() => _pressed = false),
      onTapCancel: widget.onTap == null
          ? null
          : () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: AppSizes.partnerSortIconSize, color: color),
            const SizedBox(width: AppSpacing.xxs),
          ],
          if (widget.showNewBadge) ...[
            Container(
              width: AppSizes.partnerNewBadgeWidth,
              height: AppSizes.partnerNewBadgeHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppPartnerColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.partnerNewBadge),
              ),
              child: const AppText('NEW', style: AppTextStyles.partnerNewBadge),
            ),
            const SizedBox(width: AppSpacing.xxs),
          ],
          AppText(widget.label, style: textStyle.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _FilterButton extends StatefulWidget {
  const _FilterButton({this.onTap});

  final VoidCallback? onTap;

  @override
  State<_FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<_FilterButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = _pressed
        ? AppPartnerColors.textPrimary
        : AppPartnerColors.textSecondary;

    return GestureDetector(
      onTapDown: widget.onTap == null
          ? null
          : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) => setState(() => _pressed = false),
      onTapCancel: widget.onTap == null
          ? null
          : () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: _pressed ? AppPartnerColors.chipPressedOverlay : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              '筛选',
              style: AppTextStyles.partnerFilterLabel.copyWith(color: color),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Icon(
              Icons.filter_list_rounded,
              size: AppSizes.partnerFilterIconSize,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
