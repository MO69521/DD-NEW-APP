import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'book_grid_section.dart';

/// 编辑推荐区块：3 列网格，外层卡片与推荐榜 [RankingSection] 一致。
class EditorPickSection extends StatelessWidget {
  const EditorPickSection({
    super.key,
    required this.books,
    this.onMoreTap,
    this.onBookTap,
  });

  final List<Book> books;
  final VoidCallback? onMoreTap;

  /// 回调携带该卡封面的屏内唯一 Hero 标签，供详情页同 tag 飞行。
  final void Function(Book book, Object coverHeroTag)? onBookTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: BookGridSection(
        title: '编辑推荐',
        actionLabel: '更多',
        onActionTap: onMoreTap,
        books: books,
        crossAxisCount: 3,
        heroNamespace: 'editorpick',
        titleContentGap: AppSpacing.md,
        onBookTap: onBookTap,
      ),
    );
  }
}
