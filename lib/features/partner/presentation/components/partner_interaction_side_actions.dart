import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 互动场景右侧竖排功能按钮（占位）。
class PartnerInteractionSideActions extends StatelessWidget {
  const PartnerInteractionSideActions({super.key});

  static const _actions = [
    (Icons.favorite, '表白'),
    (Icons.menu_book_outlined, '番外'),
    (Icons.smart_toy_outlined, 'AI群聊'),
    (Icons.favorite_border, '约会'),
    (Icons.checkroom_outlined, '衣橱'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _actions.length; i++) ...[
          if (i > 0)
            SizedBox(height: AppSizes.partnerInteractionSideActionSpacing),
          _SideActionButton(
            icon: _actions[i].$1,
            label: _actions[i].$2,
            onTap: () {},
          ),
        ],
      ],
    );
  }
}

class _SideActionButton extends StatelessWidget {
  const _SideActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.partnerInteractionSideActionSize,
            height: AppSizes.partnerInteractionSideActionSize,
            decoration: BoxDecoration(
              color: AppPartnerColors.interactionSideActionBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: AppSizes.partnerInteractionSideActionIconSize,
              color: AppPartnerColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.partnerInteractionSideActionLabelGap),
          AppText(label, style: AppTextStyles.partnerInteractionSideActionLabel),
        ],
      ),
    );
  }
}
