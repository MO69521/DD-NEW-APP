import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';

/// L2 — 顶部栏通用文字动作：仅文字与点击热区，无背景填充。
class AppTopBarTextButton extends StatelessWidget {
  const AppTopBarTextButton({
    super.key,
    required this.label,
    this.style,
    this.onTap,
  });

  final String label;
  final TextStyle? style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: AppText(
          label,
          style: style ?? AppTextStyles.bodyMediumDark,
          maxLines: 1,
        ),
      ),
    );
  }
}
