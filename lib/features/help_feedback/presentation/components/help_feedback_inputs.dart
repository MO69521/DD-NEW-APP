import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// 必填项标签：红色 `*` + 文案。
class HelpFeedbackRequiredLabel extends StatelessWidget {
  const HelpFeedbackRequiredLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          '*',
          style: AppTextStyles.bodyMediumDark.copyWith(color: AppColors.error),
        ),
        const SizedBox(width: AppSpacing.xxs),
        AppText(label, style: AppTextStyles.bodyMediumDark),
      ],
    );
  }
}

/// 多行问题描述输入（右下角字数计数）。
class HelpFeedbackDescriptionInput extends StatelessWidget {
  const HelpFeedbackDescriptionInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSizes.helpFeedbackDescriptionMinHeight,
      ),
      child: Stack(
        children: [
          TextFormField(
            initialValue: value,
            maxLength: AppSizes.helpFeedbackDescriptionMaxLength,
            maxLines: AppSizes.helpFeedbackDescriptionMaxLines,
            onChanged: onChanged,
            style: AppTextStyles.bodyMediumDark,
            decoration: helpFeedbackInputDecoration(
              '请描述具体问题，比如在何种情况下触发、具体表现、出现频率等等',
            ).copyWith(counterText: ''),
          ),
          Positioned(
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: AppText(
              '${value.length}/${AppSizes.helpFeedbackDescriptionMaxLength}',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textOnDarkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 单行输入（书籍名称 / 联系方式）。
class HelpFeedbackSingleLineInput extends StatelessWidget {
  const HelpFeedbackSingleLineInput({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.keyboardType,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.helpFeedbackInputMinHeight,
      child: TextFormField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: AppTextStyles.bodyMediumDark,
        decoration: helpFeedbackInputDecoration(hintText),
      ),
    );
  }
}

/// 反馈表单输入框统一装饰：玻璃细线边框 + 聚焦加深填充。
InputDecoration helpFeedbackInputDecoration(String hintText) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: const BorderSide(
      color: AppColors.borderGlass,
      width: AppSizes.hairline,
    ),
  );

  return InputDecoration(
    filled: true,
    // 聚焦态填充更明显，不使用黄色描边，边框保持统一玻璃细线。
    // 走主题语义面（深色弱实体面 / 浅色浅实体面），避免浅色下白底叠白看不见。
    fillColor: WidgetStateColor.resolveWith(
      (states) => states.contains(WidgetState.focused)
          ? AppColors.surface
          : AppColors.surfaceSoft,
    ),
    hintText: hintText,
    hintStyle: AppTextStyles.bodyMediumDarkMuted.copyWith(
      color: AppColors.textOnDarkMuted,
    ),
    contentPadding: const EdgeInsets.all(AppSpacing.md),
    enabledBorder: border,
    focusedBorder: border,
  );
}
