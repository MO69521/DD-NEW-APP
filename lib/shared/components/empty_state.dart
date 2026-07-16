import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';

/// Level 2 — 空状态组合组件。
///
/// 纯文案门闸与带插图引导共用同一组件；插图场景通过 [illustration] /
/// [contentWidth] / 外边距定制，避免各 feature 再抄一套 Column。
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.description,
    this.action,
    this.illustration,
    this.contentWidth,
    this.padding,
    this.illustrationGap = AppSpacing.md,
    this.actionGap = AppSpacing.md,
    this.titleStyle,
  });

  final String title;
  final String? description;
  final Widget? action;
  final Widget? illustration;
  final double? contentWidth;
  final EdgeInsetsGeometry? padding;
  final double illustrationGap;
  final double actionGap;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (illustration != null) ...[
          illustration!,
          SizedBox(height: illustrationGap),
        ],
        AppText(
          title,
          style:
              titleStyle ??
              AppTextStyles.titleMedium.copyWith(color: AppColors.textOnDark),
          textAlign: TextAlign.center,
        ),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.xs),
          AppText(
            description!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textOnDarkPlaceholder,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (action != null) ...[SizedBox(height: actionGap), action!],
      ],
    );

    final content = contentWidth == null
        ? column
        : SizedBox(width: contentWidth, child: column);

    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        child: content,
      ),
    );
  }
}
