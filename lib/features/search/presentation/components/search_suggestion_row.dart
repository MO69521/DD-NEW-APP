import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_icon_assets.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/search_suggestion.dart';

/// L3 — 搜索联想行：放大镜 + 词条（命中关键词高亮橙色）+ 可选标签。
class SearchSuggestionRow extends StatelessWidget {
  const SearchSuggestionRow({
    super.key,
    required this.suggestion,
    required this.query,
    this.onTap,
  });

  final SearchSuggestion suggestion;
  final String query;
  final VoidCallback? onTap;

  static const String _iconAsset = AppIconAssets.search;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.bodyLarge.copyWith(color: AppColors.textOnDark);
    final highlight = base.copyWith(color: AppColors.searchHotAccent);

    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            const AppIcon(
              assetPath: _iconAsset,
              width: AppSizes.searchInputIconSize,
              height: AppSizes.searchInputIconSize,
              color: AppColors.textOnDarkPlaceholder,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text.rich(
                TextSpan(children: _buildSpans(base, highlight)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (suggestion.badge != null) ...[
              const SizedBox(width: AppSpacing.xs),
              _SuggestionBadge(label: suggestion.badge!),
            ],
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _buildSpans(TextStyle base, TextStyle highlight) {
    final keyword = suggestion.keyword;
    if (query.isEmpty) {
      return [TextSpan(text: keyword, style: base)];
    }

    final spans = <InlineSpan>[];
    var start = 0;
    while (start < keyword.length) {
      final index = keyword.indexOf(query, start);
      if (index < 0) {
        spans.add(TextSpan(text: keyword.substring(start), style: base));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: keyword.substring(start, index), style: base));
      }
      spans.add(
        TextSpan(
          text: keyword.substring(index, index + query.length),
          style: highlight,
        ),
      );
      start = index + query.length;
    }
    return spans;
  }
}

class _SuggestionBadge extends StatelessWidget {
  const _SuggestionBadge({required this.label});

  final String label;

  bool get _isHot => label == '热搜';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xxsHalf,
      ),
      decoration: BoxDecoration(
        color: _isHot ? AppColors.searchHotAccent : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: AppText(
        label,
        style: AppTextStyles.captionSm.copyWith(
          color: _isHot ? AppColors.textOnDark : AppColors.textOnDarkMuted,
        ),
      ),
    );
  }
}
