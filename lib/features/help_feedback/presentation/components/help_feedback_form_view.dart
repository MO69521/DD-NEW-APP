import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_selection_mark.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/help_feedback_state.dart';
import '../../domain/entities/help_feedback_issue_type.dart';

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
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
              ),
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
        _DescriptionInput(value: description, onChanged: onDescriptionChanged),
        if (errorMessage != null) ...[
          const SizedBox(height: AppSpacing.xs),
          AppText(
            errorMessage!,
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.error),
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
        _UploadSection(
          paths: screenshotPaths,
          onPick: onPickScreenshot,
          onRemove: onRemoveScreenshot,
        ),
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
    return AppPressable(
      onTap: onTap,
      child: Row(
        children: [
          AppSelectionMark(isSelected: isSelected),
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
        const SizedBox(width: AppSpacing.xxs),
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

/// 问题截图上传区：已选缩略图 + 「点击上传」方形位（未达上限时展示）。
class _UploadSection extends StatelessWidget {
  const _UploadSection({required this.paths, this.onPick, this.onRemove});

  final List<String> paths;
  final VoidCallback? onPick;
  final ValueChanged<String>? onRemove;

  @override
  Widget build(BuildContext context) {
    final canAdd = paths.length < HelpFeedbackState.maxScreenshots;
    const perRow = HelpFeedbackState.maxScreenshots; // 一行展示 4 个
    const spacing = AppSpacing.sm;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 方形位宽度按「一行 4 个」等分可用宽度（floor 避免亚像素换行）。
        final tileSize =
            ((constraints.maxWidth - spacing * (perRow - 1)) / perRow)
                .floorToDouble();
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final path in paths)
              _ScreenshotThumbnail(
                path: path,
                size: tileSize,
                onRemove: onRemove == null ? null : () => onRemove!(path),
              ),
            if (canAdd) _AddUploadTile(size: tileSize, onTap: onPick),
          ],
        );
      },
    );
  }
}

class _AddUploadTile extends StatelessWidget {
  const _AddUploadTile({required this.size, this.onTap});

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 1:1 方形上传位：纯白 4% 填充，无描边。
    return AppPressable(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
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

class _ScreenshotThumbnail extends StatelessWidget {
  const _ScreenshotThumbnail({
    required this.path,
    required this.size,
    this.onRemove,
  });

  final String path;
  final double size;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: radius,
              child: Image.file(File(path), fit: BoxFit.cover),
            ),
          ),
          if (onRemove != null)
            Positioned(
              top: -AppSpacing.xs,
              right: -AppSpacing.xs,
              child: AppPressable(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xxsHalf),
                  decoration: const BoxDecoration(
                    color: AppColors.overlayScrim80,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: AppSizes.helpFeedbackUploadRemoveIconSize,
                    color: AppColors.textOnDark,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration(String hintText) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: const BorderSide(
      color: AppColors.borderGlass,
      width: AppSizes.hairline,
    ),
  );

  return InputDecoration(
    filled: true,
    // 聚焦态加深填充（4%→8%），不使用黄色描边，边框保持统一玻璃细线。
    fillColor: WidgetStateColor.resolveWith(
      (states) => states.contains(WidgetState.focused)
          ? AppColors.white08
          : AppColors.white04,
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
