import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/app_text.dart';

/// 讨论区快速回复弹层，仅负责输入与返回文本。
class BookDetailQuickReplySheet {
  static Future<String?> show(
    BuildContext context, {
    required String authorName,
  }) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.dialogBackground,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
        return _QuickReplySheetContent(
          authorName: authorName,
          bottomInset: bottomInset,
        );
      },
    );
  }
}

class _QuickReplySheetContent extends StatefulWidget {
  const _QuickReplySheetContent({
    required this.authorName,
    required this.bottomInset,
  });

  final String authorName;
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
            '回复 ${widget.authorName}',
            style: AppTextStyles.bookDetailSectionTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: AppTextStyles.bookDetailDiscussionBody,
              decoration: InputDecoration(
                border: InputBorder.none,
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
            child: TextButton(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isEmpty) return;
                AppRouter.pop(text);
              },
              child: AppText(
                '发送',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.accentYellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
