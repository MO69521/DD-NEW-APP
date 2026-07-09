import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

/// L3 — 会员页轮播指示点（选中态加宽白点，未选中态白 20%）。
///
/// 会员 Hero 与会员特权详情页统一复用。
class MembershipDots extends StatelessWidget {
  const MembershipDots({
    super.key,
    required this.count,
    required this.current,
  });

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xxs),
          DecoratedBox(
            decoration: BoxDecoration(
              color: i == current
                  ? AppColors.textOnDark
                  : AppMembershipColors.dotInactive,
              borderRadius: BorderRadius.circular(
                AppSizes.membershipDotSize / 2,
              ),
            ),
            child: SizedBox(
              width: i == current
                  ? AppSizes.membershipDotsActiveWidth
                  : AppSizes.membershipDotSize,
              height: AppSizes.membershipDotSize,
            ),
          ),
        ],
      ],
    );
  }
}
