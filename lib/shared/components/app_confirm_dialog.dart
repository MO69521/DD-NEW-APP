import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text.dart';
import 'dialog_close_button.dart';

/// L2 — 居中确认弹窗壳（面板 chrome + 标题/正文 + 双按钮）。
///
/// 遮罩仍走 [showAppBlurredDialog]；本组件只负责弹窗本体。
/// 默认左次右主（取消 secondary / 确认 accent）；特殊场景可覆写变体与文案。
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    this.message,
    this.body,
    this.titleBodyGap = AppSpacing.sm,
    this.secondaryLabel = '取消',
    this.primaryLabel = '确认',
    this.secondaryVariant = AppButtonVariant.secondary,
    this.primaryVariant = AppButtonVariant.accent,
    this.secondaryResult = false,
    this.primaryResult = true,
    this.onSecondary,
    this.onPrimary,
    this.showCloseButton = false,
    this.singlePrimary = false,
  });

  final String title;
  final String? message;
  final Widget? body;
  final double titleBodyGap;
  final String secondaryLabel;
  final String primaryLabel;
  final AppButtonVariant secondaryVariant;
  final AppButtonVariant primaryVariant;
  final Object? secondaryResult;
  final Object? primaryResult;
  final VoidCallback? onSecondary;
  final VoidCallback? onPrimary;
  final bool showCloseButton;

  /// 仅展示主按钮（如协议确认「同意并登录」）。
  final bool singlePrimary;

  @override
  Widget build(BuildContext context) {
    final content =
        body ??
        (message == null
            ? null
            : AppText(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textOnDarkMuted,
                ),
                textAlign: TextAlign.center,
              ));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.dialogBackground,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textOnDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (content != null) ...[
                    SizedBox(height: titleBodyGap),
                    content,
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  if (singlePrimary)
                    AppButton(
                      label: primaryLabel,
                      variant: primaryVariant,
                      isExpanded: true,
                      onPressed: () {
                        onPrimary?.call();
                        Navigator.of(context).pop(primaryResult);
                      },
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: secondaryLabel,
                            variant: secondaryVariant,
                            onPressed: () {
                              onSecondary?.call();
                              Navigator.of(context).pop(secondaryResult);
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppButton(
                            label: primaryLabel,
                            variant: primaryVariant,
                            onPressed: () {
                              onPrimary?.call();
                              Navigator.of(context).pop(primaryResult);
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (showCloseButton)
              Positioned(
                top: AppSpacing.lg,
                right: AppSpacing.lg,
                child: DialogCloseButton(
                  onTap: () => Navigator.of(context).pop(secondaryResult),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
