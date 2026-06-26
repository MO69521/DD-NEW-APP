import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// 讨论 / 更新 Tab 占位（功能开发中）。
class BookDetailPlaceholderView extends StatelessWidget {
  const BookDetailPlaceholderView({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Center(
        child: AppText(
          '$label功能开发中，敬请期待',
          style: AppTextStyles.bookDetailPlaceholder,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
