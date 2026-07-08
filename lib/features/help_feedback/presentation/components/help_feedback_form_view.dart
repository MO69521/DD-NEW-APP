import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/help_feedback_issue_type.dart';

/// L3 — 意见反馈表单。
class HelpFeedbackFormView extends StatelessWidget {
  const HelpFeedbackFormView({
    super.key,
    required this.issueTypes,
    required this.selectedIssueTypeId,
    required this.description,
    this.errorMessage,
    this.submitMessage,
    required this.onIssueTypeSelected,
    required this.onDescriptionChanged,
    required this.onBookNameChanged,
    required this.onPhoneChanged,
    required this.onQqChanged,
    required this.onSubmit,
  });

  final List<HelpFeedbackIssueType> issueTypes;
  final String? selectedIssueTypeId;
  final String description;
  final String? errorMessage;
  final String? submitMessage;
  final ValueChanged<String> onIssueTypeSelected;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onBookNameChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onQqChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        _FeedbackSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText('问题类型', style: AppTextStyles.bodyMediumDark),
              const SizedBox(height: AppSpacing.sm),
              _IssueTypeGrid(
                issueTypes: issueTypes,
                selectedIssueTypeId: selectedIssueTypeId,
                onSelected: onIssueTypeSelected,
              ),
              const SizedBox(height: AppSpacing.lg),
              _RequiredLabel(label: '问题描述'),
              const SizedBox(height: AppSpacing.sm),
              _DescriptionInput(
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
                    color: AppColors.accentYellow,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppText(
                '问题截图（上传截图能更快解决问题，最多4张哦～）',
                style: AppTextStyles.bodyMediumDarkMuted,
              ),
              const SizedBox(height: AppSpacing.sm),
              const _UploadPlaceholder(),
              const SizedBox(height: AppSpacing.lg),
              AppText('书籍名称', style: AppTextStyles.bodyMediumDark),
              const SizedBox(height: AppSpacing.sm),
              _SingleLineInput(
                hintText: '非阅读问题，可以不填哦～',
                onChanged: onBookNameChanged,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText('联系方式', style: AppTextStyles.bodyMediumDark),
              const SizedBox(height: AppSpacing.sm),
              _SingleLineInput(
                hintText: '输入手机号',
                keyboardType: TextInputType.phone,
                onChanged: onPhoneChanged,
              ),
              const SizedBox(height: AppSpacing.sm),
              _SingleLineInput(
                hintText: '输入QQ号',
                keyboardType: TextInputType.number,
                onChanged: onQqChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: '提交',
          variant: AppButtonVariant.accent,
          isExpanded: true,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  const _FeedbackSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.borderGlass,
          width: AppSizes.hairline,
        ),
      ),
      child: child,
    );
  }
}

class _IssueTypeGrid extends StatelessWidget {
  const _IssueTypeGrid({
    required this.issueTypes,
    required this.selectedIssueTypeId,
    required this.onSelected,
  });

  final List<HelpFeedbackIssueType> issueTypes;
  final String? selectedIssueTypeId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < issueTypes.length; i += 2) {
      final first = issueTypes[i];
      final second = i + 1 < issueTypes.length ? issueTypes[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + 2 >= issueTypes.length ? 0 : AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: _IssueTypeOption(
                  issueType: first,
                  isSelected: first.id == selectedIssueTypeId,
                  onTap: () => onSelected(first.id),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: second == null
                    ? const SizedBox.shrink()
                    : _IssueTypeOption(
                        issueType: second,
                        isSelected: second.id == selectedIssueTypeId,
                        onTap: () => onSelected(second.id),
                      ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}

class _IssueTypeOption extends StatelessWidget {
  const _IssueTypeOption({
    required this.issueType,
    required this.isSelected,
    required this.onTap,
  });

  final HelpFeedbackIssueType issueType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: AppSizes.helpFeedbackIssueTypeRadioSize,
            height: AppSizes.helpFeedbackIssueTypeRadioSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.accentYellow
                    : AppColors.borderGlass,
                width: AppSizes.borderWidthEmphasis,
              ),
            ),
            child: isSelected
                ? Container(
                    width: AppSizes.iconSm,
                    height: AppSizes.iconSm,
                    decoration: const BoxDecoration(
                      color: AppColors.accentYellow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.backgroundDark,
                      size: AppSizes.iconSm,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: AppText(
              issueType.label,
              style: AppTextStyles.bodyMediumDarkMuted.copyWith(
                color: isSelected
                    ? AppColors.textOnDark
                    : AppColors.textOnDarkMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          '*',
          style: AppTextStyles.bodyMediumDark.copyWith(color: AppColors.error),
        ),
        AppText(label, style: AppTextStyles.bodyMediumDark),
      ],
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({required this.value, required this.onChanged});

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
            decoration: _inputDecoration(
              '请描述具体问题，比如在何种情况下触发、具体表现、出现频率等等',
            ).copyWith(counterText: ''),
          ),
          Positioned(
            right: AppSpacing.sm,
            bottom: AppSpacing.sm,
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

class _SingleLineInput extends StatelessWidget {
  const _SingleLineInput({
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
        decoration: _inputDecoration(hintText),
      ),
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  const _UploadPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.borderGlass,
          width: AppSizes.hairline,
        ),
      ),
      child: Container(
        width: AppSizes.helpFeedbackUploadBoxSize,
        height: AppSizes.helpFeedbackUploadBoxSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.borderGlass,
            width: AppSizes.hairline,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_rounded,
              color: AppColors.textOnDarkMuted,
              size: AppSizes.topBarActionIconSize,
            ),
            const SizedBox(height: AppSpacing.xxs),
            AppText(
              '点击上传',
              style: AppTextStyles.captionMdDarkMuted,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hintText) {
  final radius = BorderRadius.circular(AppRadius.md);

  return InputDecoration(
    filled: true,
    fillColor: AppColors.backgroundDark.withValues(alpha: 0.32),
    hintText: hintText,
    hintStyle: AppTextStyles.bodyMediumDarkMuted.copyWith(
      color: AppColors.textOnDarkMuted,
    ),
    contentPadding: const EdgeInsets.all(AppSpacing.md),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(
        color: AppColors.borderGlass,
        width: AppSizes.hairline,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(
        color: AppColors.accentYellow,
        width: AppSizes.borderWidthEmphasis,
      ),
    ),
  );
}
