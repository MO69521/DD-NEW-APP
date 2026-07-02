import 'package:flutter/material.dart';

import '../../../../core/constants/currency_config.dart';
import '../../../../core/domain/entities/commerce_entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/currency_wallet_page_content.dart';
import 'currency_wallet_section_card.dart';

class CurrencyLedgerSection extends StatelessWidget {
  const CurrencyLedgerSection({
    super.key,
    required this.type,
    required this.records,
  });

  final CurrencyType type;
  final List<CurrencyLedgerRecord> records;

  @override
  Widget build(BuildContext context) {
    return CurrencyWalletSectionCard(
      title: '获得记录',
      trailing: AppText(
        '只展示最近30天获得${CurrencyConfig.label(type)}记录',
        style: AppTextStyles.captionMdDarkMuted,
      ),
      child: records.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(
                child: AppText(
                  '没有更多内容~',
                  style: AppTextStyles.bodyMediumDarkMuted,
                ),
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < records.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.md),
                  _LedgerRecordRow(record: records[i]),
                ],
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: AppText(
                    '没有更多内容~',
                    style: AppTextStyles.bodyMediumDarkMuted,
                  ),
                ),
              ],
            ),
    );
  }
}

class _LedgerRecordRow extends StatelessWidget {
  const _LedgerRecordRow({required this.record});

  final CurrencyLedgerRecord record;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(record.title, style: AppTextStyles.bodyMediumDark),
              const SizedBox(height: AppSpacing.xxs),
              AppText(
                record.timeLabel,
                style: AppTextStyles.bodyMediumDarkMuted,
              ),
            ],
          ),
        ),
        AppText(
          record.amountDelta > 0
              ? '+${record.amountDelta}'
              : '${record.amountDelta}',
          style: AppTextStyles.bodyMediumDark.copyWith(
            color: AppColors.bookDetailUpdateTextHighlighted,
          ),
        ),
      ],
    );
  }
}
