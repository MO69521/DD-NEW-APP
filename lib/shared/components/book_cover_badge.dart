import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';

/// Level 2 — 封面左上角文字角标（深色玻璃态）。
///
/// 纯 label 驱动、零业务：连载/完结/更新等由调用方传入字符串。
class BookCoverBadge extends StatelessWidget {
  const BookCoverBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.searchStatusBadgeBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.searchStatusBadge),
          bottomRight: Radius.circular(AppRadius.searchStatusBadge),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.insetXs,
          vertical: AppSpacing.xxsHalf,
        ),
        child: AppText(label, style: AppTextStyles.searchStatusBadge),
      ),
    );
  }
}
