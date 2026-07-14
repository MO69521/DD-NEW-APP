import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/book_card_skeletons.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/search_cubit.dart';
import '../../application/search_domain_state.dart';
import 'search_clear_history_dialog.dart';
import 'search_keyword_section.dart';
import 'search_recommendation_row.dart';

/// 搜索初始态（无关键词）：搜索历史 + 热门搜索 + 热搜书籍；均为空时展示引导文案。
class SearchEmptyBody extends StatelessWidget {
  const SearchEmptyBody({
    super.key,
    required this.domain,
    required this.isRecommendationsLoading,
    required this.emptyCaption,
  });

  final SearchDomainState domain;
  final bool isRecommendationsLoading;
  final String emptyCaption;

  static const double _bottomReserve = AppSpacing.xxl;

  Future<void> _confirmClearHistory(
    BuildContext context,
    SearchCubit cubit,
  ) async {
    final confirmed = await showAppBlurredDialog<bool>(
      context: context,
      builder: (_) => const SearchClearHistoryDialog(),
    );
    if (confirmed == true) {
      await cubit.clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isRecommendationsLoading) {
      return BookLargeRowListSkeleton(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppLayout.chromeTopHeight(context) + AppSpacing.md,
          AppSpacing.md,
          0,
        ),
      );
    }

    final hasHistory = domain.searchHistory.isNotEmpty;
    final hasHot = domain.hotKeywords.isNotEmpty;
    final hasRecommend = domain.recommendations.isNotEmpty;

    if (!hasHistory && !hasHot && !hasRecommend) {
      return EmptyState(title: emptyCaption);
    }

    final cubit = context.read<SearchCubit>();
    final topInset = AppLayout.chromeTopHeight(context) + AppSpacing.md;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              topInset,
              AppSpacing.md,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasHistory) ...[
                  SearchKeywordSection(
                    title: '搜索历史',
                    keywords: domain.searchHistory,
                    onClear: () => _confirmClearHistory(context, cubit),
                    onKeywordTap: cubit.search,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
                if (hasHot) ...[
                  SearchKeywordSection(
                    title: '热门搜索',
                    keywords: domain.hotKeywords,
                    highlightFirst: true,
                    onKeywordTap: cubit.search,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
                if (hasRecommend) ...[
                  AppText(
                    '热搜书籍',
                    style: AppTextStyles.sectionTitleDark.copyWith(
                      color: AppColors.textOnDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          ),
        ),
        if (hasRecommend)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              _bottomReserve,
            ),
            sliver: SliverList.separated(
              itemCount: domain.recommendations.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) => Row(
                children: [
                  _SearchRankNumber(rank: index + 1),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: SearchRecommendationRow(
                      item: domain.recommendations[index],
                      onTap: AppRouter.goBookDetail,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// 热搜书籍名次编号：前三名 红 / 橙 / 黄，其余白色 60%。
class _SearchRankNumber extends StatelessWidget {
  const _SearchRankNumber({required this.rank});

  final int rank;

  Color get _color => switch (rank) {
    1 => AppColors.error,
    2 => AppColors.searchHotAccent,
    3 => AppColors.accentYellow,
    _ => AppColors.textOnDarkPlaceholder,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.lg,
      child: AppText(
        '$rank',
        style: TextStyle(
          fontSize: AppFontSizes.xl,
          fontWeight: rank <= 3 ? AppFontWeights.bold : AppFontWeights.regular,
          color: _color,
          height: AppLineHeights.none,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
