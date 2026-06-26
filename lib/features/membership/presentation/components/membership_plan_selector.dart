import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../domain/entities/membership_plan.dart';
import 'membership_plan_card.dart';

/// L3 — 套餐横向选择器（单选）。
class MembershipPlanSelector extends StatelessWidget {
  const MembershipPlanSelector({
    super.key,
    required this.plans,
    required this.selectedPlanId,
    this.onSelect,
  });

  final List<MembershipPlan> plans;
  final String? selectedPlanId;
  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.membershipPlanCardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: plans.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppSizes.membershipPlanSelectorGap),
        itemBuilder: (context, index) {
          final plan = plans[index];
          return MembershipPlanCard(
            plan: plan,
            selected: plan.id == selectedPlanId,
            onTap: () => onSelect?.call(plan.id),
          );
        },
      ),
    );
  }
}
