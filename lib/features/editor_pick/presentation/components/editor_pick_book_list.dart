import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/editor_pick_book_item.dart';
import 'editor_pick_book_row.dart';

/// L3 — 编辑推荐详情列表（builder 渲染的 sliver，行间分隔线）。
class EditorPickBookList extends StatelessWidget {
  const EditorPickBookList({
    super.key,
    required this.items,
    this.onItemTap,
  });

  final List<EditorPickBookItem> items;
  final void Function(Book book)? onItemTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final row = EditorPickBookRow(
              item: items[index],
              onTap: onItemTap,
            );
            if (index == 0) return row;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(
                  height: AppSizes.hairline,
                  thickness: AppSizes.hairline,
                  color: AppColors.borderGlass,
                ),
                row,
              ],
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
