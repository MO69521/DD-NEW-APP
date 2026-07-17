import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/help_feedback_issue_type.dart';
import 'help_feedback_inputs.dart';
import 'help_feedback_issue_type_grid.dart';
import 'help_feedback_upload_section.dart';

/// L3 — 意见反馈表单。
class HelpFeedbackFormView extends StatelessWidget {
  const HelpFeedbackFormView({
    super.key,
    required this.issueTypes,
    required this.selectedIssueTypeId,
    required this.description,
    this.screenshotPaths = const [],
    this.errorMessage,
    this.submitMessage,
    required this.onIssueTypeSelected,
    required this.onDescriptionChanged,
    required this.onBookNameChanged,
    required this.onPhoneChanged,
    required this.onQqChanged,
    this.onPickScreenshot,
    this.onRemoveScreenshot,
    required this.onSubmit,
  });

  final List<HelpFeedbackIssueType> issueTypes;
  final String? selectedIssueTypeId;
  final String description;
  final List<String> screenshotPaths;
  final String? errorMessage;
  final String? submitMessage;
  final ValueChanged<String> onIssueTypeSelected;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onBookNameChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onQqChanged;
  final VoidCallback? onPickScreenshot;
  final ValueChanged<String>? onRemoveScreenshot;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          // 点击非聚焦区域 / 拖动列表时收起键盘，输入框回到未选中态。
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppText('问题类型', style: AppTextStyles.bodyMediumDark),
                const SizedBox(height: AppSpacing.sm),
                HelpFeedbackIssueTypeGrid(
                  issueTypes: issueTypes,
                  selectedIssueTypeId: selectedIssueTypeId,
                  onSelected: onIssueTypeSelected,
                ),
                const SizedBox(height: AppSpacing.lg),
                const HelpFeedbackRequiredLabel(label: '问题描述'),
                const SizedBox(height: AppSpacing.sm),
                HelpFeedbackDescriptionInput(
                  value: description,
                  onChanged: onDescriptionChanged,
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    errorMessage!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
                if (submitMessage != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    submitMessage!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.accentText,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                AppText(
                  '问题截图（上传截图能更快解决问题，最多4张哦～）',
                  style: AppTextStyles.bodyMediumDarkMuted,
                ),
                const SizedBox(height: AppSpacing.sm),
                HelpFeedbackUploadSection(
                  paths: screenshotPaths,
                  onPick: onPickScreenshot,
                  onRemove: onRemoveScreenshot,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppText('书籍名称', style: AppTextStyles.bodyMediumDark),
                const SizedBox(height: AppSpacing.sm),
                HelpFeedbackSingleLineInput(
                  hintText: '非阅读问题，可以不填哦～',
                  onChanged: onBookNameChanged,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppText('联系方式', style: AppTextStyles.bodyMediumDark),
                const SizedBox(height: AppSpacing.sm),
                HelpFeedbackSingleLineInput(
                  hintText: '输入手机号',
                  keyboardType: TextInputType.phone,
                  onChanged: onPhoneChanged,
                ),
                const SizedBox(height: AppSpacing.sm),
                HelpFeedbackSingleLineInput(
                  hintText: '输入QQ号',
                  keyboardType: TextInputType.number,
                  onChanged: onQqChanged,
                ),
              ],
            ),
          ),
        ),
        _SubmitBar(onSubmit: onSubmit),
      ],
    );
  }
}

/// 固定在表单底部的提交栏（避让底部安全区）。
class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: AppButton(
          label: '提交',
          variant: AppButtonVariant.accent,
          isExpanded: true,
          onPressed: onSubmit,
        ),
      ),
    );
  }
}
