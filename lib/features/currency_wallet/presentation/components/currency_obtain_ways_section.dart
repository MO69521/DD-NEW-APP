import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/currency_wallet_page_content.dart';
import 'currency_wallet_section_card.dart';

class CurrencyObtainWaysSection extends StatelessWidget {
  const CurrencyObtainWaysSection({
    super.key,
    required this.ways,
    required this.onAction,
  });

  final List<CurrencyObtainWay> ways;
  final ValueChanged<CurrencyWalletAction> onAction;

  @override
  Widget build(BuildContext context) {
    if (ways.isEmpty) return const SizedBox.shrink();

    return CurrencyWalletSectionCard(
      title: '获得途径',
      child: Column(
        children: [
          for (var i = 0; i < ways.length; i++) ...[
            _ObtainWayRow(way: ways[i], onAction: onAction),
            if (i < ways.length - 1)
              const Divider(
                height: AppSpacing.md,
                color: AppColors.borderGlass,
              ),
          ],
        ],
      ),
    );
  }
}

class _ObtainWayRow extends StatelessWidget {
  const _ObtainWayRow({required this.way, required this.onAction});

  final CurrencyObtainWay way;
  final ValueChanged<CurrencyWalletAction> onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              way.title,
              style: AppTextStyles.bodyMediumDark,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppButton(
            label: way.actionLabel,
            size: AppButtonSize.small,
            variant: AppButtonVariant.secondary,
            onPressed: () => onAction(way.action),
          ),
        ],
      ),
    );
  }
}
