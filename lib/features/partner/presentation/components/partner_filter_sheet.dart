import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 筛选 BottomSheet（深色玻璃态 + 粉色选中）。
class PartnerFilterSheet extends StatelessWidget {
  const PartnerFilterSheet({
    super.key,
    required this.options,
    required this.selectedIndex,
    this.onOptionSelected,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int>? onOptionSelected;

  static Future<void> show(
    BuildContext context, {
    required List<String> options,
    required int selectedIndex,
    ValueChanged<int>? onOptionSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return PartnerFilterSheet(
          options: options,
          selectedIndex: selectedIndex,
          onOptionSelected: (index) {
            onOptionSelected?.call(index);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.partnerFilterSheet),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSizes.glassBlurSigma,
          sigmaY: AppSizes.glassBlurSigma,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppPartnerColors.surfaceGlass,
            border: Border(
              top: BorderSide(color: AppPartnerColors.borderGlass),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: AppText(
                    '筛选',
                    style: AppTextStyles.partnerFilterSheetTitle,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (var i = 0; i < options.length; i++)
                  _FilterOptionTile(
                    label: options[i],
                    selected: i == selectedIndex,
                    onTap: onOptionSelected == null
                        ? null
                        : () => onOptionSelected!(i),
                  ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterOptionTile extends StatefulWidget {
  const _FilterOptionTile({
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  State<_FilterOptionTile> createState() => _FilterOptionTileState();
}

class _FilterOptionTileState extends State<_FilterOptionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.selected
        ? AppTextStyles.partnerFilterSheetOptionSelected
        : AppTextStyles.partnerFilterSheetOption;

    return Material(
      color: _pressed
          ? AppPartnerColors.chipPressedOverlay
          : Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onHighlightChanged: (value) => setState(() => _pressed = value),
        child: SizedBox(
          height: AppSizes.partnerFilterSheetOptionHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(child: AppText(widget.label, style: textStyle)),
                if (widget.selected)
                  const Icon(
                    Icons.check_rounded,
                    size: AppSizes.partnerFilterIconSize,
                    color: AppPartnerColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
