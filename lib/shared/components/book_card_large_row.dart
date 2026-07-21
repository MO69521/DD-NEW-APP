import 'package:flutter/material.dart';

import '../../core/domain/entities/book_cover_tag.dart';
import '../../core/domain/entities/book_cover_bottom_badge.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';
import '../widgets/book_cover.dart';
import 'book_cover_tag_badge.dart';
import 'book_cover_bottom_badge.dart';

/// Level 2 — 大封面横向书卡：左封面(可叠角标) + 右标题/标签/简介/脚注 + 尾部操作位。
///
/// 分类、榜单、搜索、编辑推荐等列表页共用此布局；feature 层通过薄封装注入业务字段。
class BookCardLargeRow extends StatelessWidget {
  const BookCardLargeRow({
    super.key,
    required this.coverAsset,
    required this.title,
    this.meta,
    this.description,
    this.footer,
    this.titleMaxLines = 1,
    this.descriptionMaxLines = 2,
    this.coverWidth = AppSizes.bookCardLargeCoverWidth,
    this.coverHeight = AppSizes.bookCardLargeCoverHeight,
    this.coverTag,
    this.coverBottomBadge,
    this.leadingBadge,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppSizes.bookCardLargeRowVerticalPadding,
    ),
    this.onTap,
    this.heroTag,
  });

  final String coverAsset;
  final String title;
  final int titleMaxLines;

  /// 副标题/标签行（如「女性向 / 未来 / 女尊」），为空则不渲染。
  final String? meta;

  /// 简介，为空则不渲染。
  final String? description;

  /// 底部脚注（如作者名），为空则不渲染。
  final String? footer;
  final int descriptionMaxLines;
  final double coverWidth;
  final double coverHeight;

  /// 封面右上角状态角标（更新 / 完结 / 连载），为空则不展示。
  final BookCoverTag? coverTag;
  final BookCoverBottomBadge? coverBottomBadge;

  /// 封面左上角业务角标（如排行名次），为空则不展示。
  final Widget? leadingBadge;

  /// 行尾操作插槽（如加入书架）。
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// 共享元素转场标签（透传给封面），仅在书 id 唯一的列表传入。
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                BookCover(
                  assetPath: coverAsset,
                  width: coverWidth,
                  height: coverHeight,
                  heroTag: heroTag,
                  topEndBadge: coverTag == null
                      ? null
                      : BookCoverTagBadge(tag: coverTag!),
                  bottomEndBadge: coverBottomBadge == null
                      ? null
                      : BookCoverBottomBadgeView(badge: coverBottomBadge!),
                ),
                if (leadingBadge != null)
                  Positioned(top: 0, left: 0, child: leadingBadge!),
              ],
            ),
            const SizedBox(width: AppSizes.bookCardLargeCoverToTextGap),
            Expanded(
              child: _RichTextBlock(
                title: title,
                titleMaxLines: titleMaxLines,
                meta: meta,
                description: description,
                footer: footer,
                descriptionMaxLines: descriptionMaxLines,
                coverHeight: coverHeight,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSizes.bookCardLargeTitleToTrailingGap),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _RichTextBlock extends StatelessWidget {
  const _RichTextBlock({
    required this.title,
    required this.titleMaxLines,
    required this.meta,
    required this.description,
    required this.footer,
    required this.descriptionMaxLines,
    required this.coverHeight,
  });

  final String title;
  final int titleMaxLines;
  final String? meta;
  final String? description;
  final String? footer;
  final int descriptionMaxLines;
  final double coverHeight;

  bool get _hasRichBody => description != null || footer != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasRichBody) {
      return SizedBox(
        height: coverHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              title,
              style: AppTextStyles.bookCardLargeTitle,
              maxLines: titleMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
            if (meta != null)
              AppText(
                meta!,
                style: AppTextStyles.bookTagDark,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      );
    }

    // 标题/标签置顶，简介 + 作者信息作为一个模块单元与封面底部对齐。
    return SizedBox(
      height: coverHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                style: AppTextStyles.bookCardLargeTitle,
                maxLines: titleMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
              if (meta != null) ...[
                const SizedBox(height: AppSizes.bookCardLargeTitleToMetaGap),
                AppText(
                  meta!,
                  style: AppTextStyles.bookTagDark,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (description != null)
                AppText(
                  description!,
                  style: AppTextStyles.bookCardLargeDescription,
                  maxLines: descriptionMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              if (description != null && footer != null)
                const SizedBox(height: AppSizes.bookCardDescToFooterGap),
              if (footer != null)
                AppText(
                  footer!,
                  style: AppTextStyles.bookCardFooter,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
