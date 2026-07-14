import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../widgets/app_pressable.dart';

/// L2 — 统一分页指示点。
///
/// 选中态白色加宽胶囊，未选中态白 20% 小圆点；会员轮播、新手引导步骤等统一复用。
/// 传入 [onDotTap] 后圆点可点击跳转（自带纵向点击热区）。
class AppPageDots extends StatelessWidget {
  const AppPageDots({
    super.key,
    required this.count,
    required this.current,
    this.onDotTap,
  });

  final int count;
  final int current;
  final ValueChanged<int>? onDotTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xxs),
          _buildDot(i),
        ],
      ],
    );
  }

  Widget _buildDot(int index) {
    final active = index == current;
    final dot = AnimatedContainer(
      duration: AppDurations.fast,
      curve: Curves.easeOutCubic,
      width: active ? AppSizes.pageDotActiveWidth : AppSizes.pageDotSize,
      height: AppSizes.pageDotSize,
      decoration: BoxDecoration(
        color: active ? AppColors.textOnDark : AppColors.white20, // light-audit: effect 分页点叠头图轮播
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );

    if (onDotTap == null) return dot;
    return AppPressable(
      onTap: () => onDotTap!(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: dot,
      ),
    );
  }
}
