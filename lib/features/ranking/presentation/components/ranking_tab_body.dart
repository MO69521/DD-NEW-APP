import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../shared/layouts/app_scroll_blur_scope.dart';
import '../../application/ranking_cubit.dart';
import '../../application/ranking_state.dart';
import 'ranking_book_row.dart';
import 'ranking_channel_segmented.dart';
import 'ranking_dimension_rail.dart';
import 'ranking_top_chrome.dart';

/// 榜单 Tab 主体：频道筛选 + 维度 rail + 书籍列表。
///
/// [embedded] 为 `true` 时用于书城页内嵌入（无返回顶栏、无 statusBar 偏移）。
class RankingTabBody extends StatelessWidget {
  const RankingTabBody({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RankingCubit, RankingState>(
      builder: (context, state) {
        if (state.ui.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.ui.errorMessage != null) {
          return EmptyState(
            title: '加载失败',
            description: state.ui.errorMessage,
            action: AppButton(
              label: '重试',
              onPressed: () => context.read<RankingCubit>().load(),
            ),
          );
        }

        return _RankingTabContent(state: state, embedded: embedded);
      },
    );
  }
}

class _RankingTabContent extends StatelessWidget {
  const _RankingTabContent({required this.state, required this.embedded});

  final RankingState state;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    if (embedded) {
      return _RankingTabStack(
        state: state,
        embedded: embedded,
        topBlurEnabled: false,
      );
    }

    return AppScrollBlurScope(
      builder: (context, topBlurEnabled) => _RankingTabStack(
        state: state,
        embedded: embedded,
        topBlurEnabled: topBlurEnabled,
      ),
    );
  }
}

class _RankingTabStack extends StatelessWidget {
  const _RankingTabStack({
    required this.state,
    required this.embedded,
    required this.topBlurEnabled,
  });

  final RankingState state;
  final bool embedded;
  final bool topBlurEnabled;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RankingCubit>();
    final statusBar = embedded ? 0.0 : AppLayout.statusBarHeight(context);

    final dimension = state.interaction.selectedDimension;
    final channel = state.interaction.selectedChannel;
    final books = state.domain.booksFor(dimension, channel);

    final bottomScrollPadding = embedded
        ? AppBottomNav.barHeight + AppSpacing.xl
        : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final topChromeHeight = AppLayout.chromeTopHeight(
          context,
          barHeight: embedded
              ? AppSizes.bookstoreTopHeaderHeight
              : AppSizes.topBarHeight,
        );
        final fixedTop = topChromeHeight + AppSizes.rankingStickyControlsTopGap;
        final segmentedWidth = AppLayout.rankingScaledDesignX(
          width,
          AppSizes.rankingSegmentedDesignWidth,
        );
        final segmentedLeft =
            width / 2 +
            AppLayout.rankingScaledDesignX(
              width,
              AppSizes.rankingSegmentedCenterOffsetX,
            ) -
            segmentedWidth / 2;
        final pinnedRailTop =
            fixedTop +
            AppSizes.rankingSegmentedHeight +
            AppSizes.rankingSegmentedToBodyGap;
        final headerHeight = pinnedRailTop;

        return ColoredBox(
          color: AppColors.backgroundDark,
          child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: headerHeight)),
                  _RankingBookSliverList(
                    books: books,
                    bottomScrollPadding: bottomScrollPadding,
                    onBookTap: AppRouter.goBookDetail,
                  ),
                ],
              ),
              Positioned(
                top: fixedTop,
                left: segmentedLeft,
                width: segmentedWidth,
                child: RankingChannelSegmented(
                  selected: channel,
                  onSelected: cubit.selectChannel,
                ),
              ),
              Positioned(
                top: pinnedRailTop,
                left: 0,
                child: RankingDimensionRail(
                  selected: dimension,
                  onSelected: cubit.selectDimension,
                ),
              ),
              if (!embedded)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: RankingTopChrome(
                    statusBarHeight: statusBar,
                    blurEnabled: topBlurEnabled,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RankingBookSliverList extends StatelessWidget {
  const _RankingBookSliverList({
    required this.books,
    required this.bottomScrollPadding,
    required this.onBookTap,
  });

  final List<Book> books;
  final double bottomScrollPadding;
  final ValueChanged<Book> onBookTap;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(title: '暂无榜单内容'),
      );
    }

    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final trailingPadding = bottomScrollPadding > 0
        ? bottomScrollPadding
        : AppSpacing.xl;

    return SliverPadding(
      padding: EdgeInsets.only(
        top: AppSizes.rankingBookListTopPadding,
        bottom: safeBottom + trailingPadding,
      ),
      sliver: SliverList.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppSizes.rankingDimensionRailWidth + AppSpacing.md,
                ),
                Expanded(
                  child: _RankingBookListItem(
                    book: book,
                    rank: index + 1,
                    showTopGap: index > 0,
                    onTap: () => onBookTap(book),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RankingBookListItem extends StatelessWidget {
  const _RankingBookListItem({
    required this.book,
    required this.rank,
    required this.showTopGap,
    required this.onTap,
  });

  final Book book;
  final int rank;
  final bool showTopGap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final row = RankingBookRow(book: book, rank: rank, onTap: onTap);
    if (!showTopGap) return row;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        row,
      ],
    );
  }
}
