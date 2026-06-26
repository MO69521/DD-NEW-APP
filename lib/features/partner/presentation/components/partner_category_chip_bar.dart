import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 横向可滚动人设分类标签。
class PartnerCategoryChipBar extends StatelessWidget {
  const PartnerCategoryChipBar({
    super.key,
    required this.tags,
    required this.selectedIndex,
    this.onSelected,
  });

  final List<String> tags;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.partnerCategoryChipHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        itemCount: tags.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppSizes.partnerCategoryChipSpacing),
        itemBuilder: (context, index) {
          return _PartnerCategoryChip(
            label: tags[index],
            selected: index == selectedIndex,
            onTap: onSelected == null ? null : () => onSelected!(index),
          );
        },
      ),
    );
  }
}

class _PartnerCategoryChip extends StatefulWidget {
  const _PartnerCategoryChip({
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  State<_PartnerCategoryChip> createState() => _PartnerCategoryChipState();
}

class _PartnerCategoryChipState extends State<_PartnerCategoryChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final disabled = widget.onTap == null;

    Color background;
    Color borderColor;
    TextStyle textStyle;

    if (selected) {
      background = _pressed
          ? AppPartnerColors.primaryMutedBg
          : AppPartnerColors.primarySubtleBg;
      borderColor = AppPartnerColors.primary;
      textStyle = AppTextStyles.partnerCategoryChipSelected;
    } else if (disabled) {
      background = AppPartnerColors.surfaceGlass;
      borderColor = AppPartnerColors.borderGlass;
      textStyle = AppTextStyles.partnerCategoryChipUnselected.copyWith(
        color: AppPartnerColors.primaryDisabled,
      );
    } else {
      background = _pressed
          ? AppPartnerColors.chipPressedOverlay
          : AppPartnerColors.surfaceGlass;
      borderColor = AppPartnerColors.borderGlass;
      textStyle = AppTextStyles.partnerCategoryChipUnselected;
    }

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSizes.partnerCategoryChipHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.partnerCategoryChipPaddingH,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.partnerCategoryChip),
          border: Border.all(color: borderColor, width: AppSizes.hairline),
        ),
        child: AppText(widget.label, style: textStyle),
      ),
    );
  }
}
