import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/membership_benefit.dart';
import 'membership_benefit_item.dart';

/// L3 — 「点点会员权益」区：窄屏 4+3 网格，宽屏（≥ breakpoint）7 项单行均分。
class MembershipBenefitsSection extends StatelessWidget {
  const MembershipBenefitsSection({super.key, required this.benefits});

  final List<MembershipBenefit> benefits;

  List<List<MembershipBenefit>> _rowsForColumns(int columns) {
    final rows = <List<MembershipBenefit>>[];
    for (var i = 0; i < benefits.length; i += columns) {
      rows.add(
        benefits.sublist(
          i,
          i + columns > benefits.length ? benefits.length : i + columns,
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.membershipCard),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxGridWidth = AppSizes.membershipBenefitGridMaxWidth;
          final useSingleRow = constraints.maxWidth >= maxGridWidth;
          final columns =
              useSingleRow ? benefits.length : AppSizes.membershipBenefitColumns;
          final rows = _rowsForColumns(columns);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText('点点会员权益', style: AppTextStyles.membershipSectionTitle),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var r = 0; r < rows.length; r++) ...[
                      if (r > 0)
                        const SizedBox(
                          height: AppSizes.membershipBenefitRowGap,
                        ),
                      _BenefitRow(
                        items: rows[r],
                        columns: columns,
                        alignPartialRowLeft: !useSingleRow,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.items,
    required this.columns,
    this.alignPartialRowLeft = false,
  });

  final List<MembershipBenefit> items;
  final int columns;
  final bool alignPartialRowLeft;

  @override
  Widget build(BuildContext context) {
    final isPartialRow =
        alignPartialRowLeft && items.length < columns;

    if (isPartialRow) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = constraints.maxWidth / columns;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final benefit in items)
                SizedBox(
                  width: cellWidth,
                  child: MembershipBenefitItem(
                    benefit: benefit,
                    centered: true,
                  ),
                ),
            ],
          );
        },
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final benefit in items)
          Expanded(
            child: MembershipBenefitItem(
              benefit: benefit,
              centered: true,
            ),
          ),
      ],
    );
  }
}
