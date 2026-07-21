import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// 讨论区快速回复 / 写评论弹层，仅负责输入与返回文本。
class BookDetailQuickReplySheet {
  static Future<String?> show(
    BuildContext context, {
    String? authorName,
    String? title,
  }) async {
    final sheetTitle =
        title ??
        (authorName == null || authorName.isEmpty
            ? '写评论'
            : '回复 $authorName');
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.dialogBackground,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
        return _QuickReplySheetContent(
          title: sheetTitle,
          bottomInset: bottomInset,
        );
      },
    );
  }
}

class _QuickReplySheetContent extends StatefulWidget {
  const _QuickReplySheetContent({
    required this.title,
    required this.bottomInset,
  });

  final String title;
  final double bottomInset;

  @override
  State<_QuickReplySheetContent> createState() =>
      _QuickReplySheetContentState();
}

class _QuickReplySheetContentState extends State<_QuickReplySheetContent> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + widget.bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            widget.title,
            style: AppTextStyles.bookDetailSectionTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          // 白底弹窗上的输入面：与帮助反馈输入一致，弱灰面 + 玻璃细描边（勿用 surfaceCard 叠白）。
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.borderGlass,
                width: AppSizes.hairline,
              ),
            ),
            child: TextField(
              controller: _controller,
              autofocus: true,
              // 正文输入用主文字色光标；勿用 searchCursor（亮黄在浅灰输入面上过抢）。
              cursorColor: AppColors.textOnDark,
              style: AppTextStyles.bookDetailDiscussionBody,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: '说点什么...',
                hintStyle: AppTextStyles.bookDetailDiscussionMeta,
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              label: '发送',
              variant: AppButtonVariant.accent,
              size: AppButtonSize.small,
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isEmpty) return;
                AppRouter.pop(text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
