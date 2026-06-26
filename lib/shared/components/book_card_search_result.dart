import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';
import '../widgets/book_cover.dart';

/// Level 2 — 富信息横向书卡变体：左封面(可叠角标) + 右标题/标签/简介 + 尾部操作位。
///
/// 纯布局组件：通过 [leadingBadge] / [trailing] 插槽接收外部 widget，
/// 不感知任何 feature 业务（状态枚举、加书架回调等由调用方注入）。
class BookCardSearchResult extends StatelessWidget {
  const BookCardSearchResult({
    super.key,
    required this.coverAsset,
    required this.title,
    this.meta,
    this.description,
    this.footer,
    this.descriptionMaxLines = 3,
    this.coverWidth = AppSizes.searchResultCoverWidth,
    this.coverHeight = AppSizes.searchResultCoverHeight,
    this.leadingBadge,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppSizes.searchResultRowVerticalPadding,
    ),
    this.onTap,
  });

  final String coverAsset;
  final String title;

  /// 副标题/标签行（如「女性向 / 未来 / 女尊」），为空则不渲染。
  final String? meta;

  /// 简介，为空则不渲染。
  final String? description;

  /// 底部脚注（如作者名），为空则不渲染。
  final String? footer;
  final int descriptionMaxLines;
  final double coverWidth;
  final double coverHeight;

  /// 叠加在封面左上角的角标插槽（如连载/完结）。
  final Widget? leadingBadge;

  /// 行尾操作插槽（如加入书架）。
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CoverWithBadge(
              coverAsset: coverAsset,
              width: coverWidth,
              height: coverHeight,
              badge: leadingBadge,
            ),
            const SizedBox(width: AppSizes.searchResultCoverToTextGap),
            Expanded(
              child: _RichTextBlock(
                title: title,
                meta: meta,
                description: description,
                footer: footer,
                descriptionMaxLines: descriptionMaxLines,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSizes.searchResultTitleToAddGap),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _CoverWithBadge extends StatelessWidget {
  const _CoverWithBadge({
    required this.coverAsset,
    required this.width,
    required this.height,
    this.badge,
  });

  final String coverAsset;
  final double width;
  final double height;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.coverSm),
      child: Stack(
        children: [
          BookCover(assetPath: coverAsset, width: width, height: height),
          if (badge != null) Positioned(top: 0, left: 0, child: badge!),
        ],
      ),
    );
  }
}

class _RichTextBlock extends StatelessWidget {
  const _RichTextBlock({
    required this.title,
    required this.meta,
    required this.description,
    required this.footer,
    required this.descriptionMaxLines,
  });

  final String title;
  final String? meta;
  final String? description;
  final String? footer;
  final int descriptionMaxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          style: AppTextStyles.searchResultTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (meta != null) ...[
          const SizedBox(height: AppSizes.searchResultTitleToTagsGap),
          AppText(
            meta!,
            style: AppTextStyles.bookTagDark,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (description != null) ...[
          const SizedBox(height: AppSizes.searchResultTagsToDescGap),
          AppText(
            description!,
            style: AppTextStyles.searchResultDescription,
            maxLines: descriptionMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (footer != null) ...[
          const SizedBox(height: AppSizes.bookCardDescToFooterGap),
          AppText(
            footer!,
            style: AppTextStyles.bookCardFooter,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
