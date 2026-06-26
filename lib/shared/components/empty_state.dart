import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';
import '../../core/theme/app_colors.dart';

/// Level 2 — 空状态组合组件。
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.description,
    this.action,
  });

  final String title;
  final String? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textOnDark,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              AppText(
                description!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textOnDarkPlaceholder,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.md),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
