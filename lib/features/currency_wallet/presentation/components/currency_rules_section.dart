import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import 'currency_wallet_section_card.dart';

class CurrencyRulesSection extends StatelessWidget {
  const CurrencyRulesSection({super.key, required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) return const SizedBox.shrink();

    return CurrencyWalletSectionCard(
      title: '规则说明',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rules.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            AppText(
              '${i + 1}.${rules[i]}',
              style: AppTextStyles.bodyMediumDarkMuted,
            ),
          ],
        ],
      ),
    );
  }
}
