import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/layouts/app_scroll_blur_scope.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/ranking_cubit.dart';
import '../../application/ranking_state.dart';
import 'ranking_book_row.dart';
import 'ranking_channel_segmented.dart';
import 'ranking_dimension_rail.dart';
import 'ranking_hero_banner.dart';

/// 榜单 Tab 主体：hero + 维度 rail + 书籍列表。
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

class _RankingTabStack extends StatefulWidget {
  const _RankingTabStack({
    required this.state,
    required this.embedded,
    required this.topBlurEnabled,
  });

  final RankingState state;
  final bool embedded;
  final bool topBlurEnabled;

  @override
  State<_RankingTabStack> createState() => _RankingTabStackState();
}

class _RankingTabStackState extends State<_RankingTabStack> {
  late final ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updatePinnedFromController);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updatePinnedFromController)
      ..dispose();
    super.dispose();
  }

  void _updatePinnedFromController() {
    _updateScrollOffset(_scrollController.offset);
  }

  void _updateScrollOffset(double scrollOffset) {
    if ((scrollOffset - _scrollOffset).abs() < AppSizes.hairline) return;
    if (mounted) {
      setState(() => _scrollOffset = scrollOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RankingCubit>();
    final statusBar = widget.embedded
        ? 0.0
        : AppLayout.statusBarHeight(context);

    final dimension = widget.state.interaction.selectedDimension;
    final channel = widget.state.interaction.selectedChannel;
    final books = widget.state.domain.booksFor(dimension, channel);
    final title = '${widget.state.domain.brandTitle} ${dimension.titleSuffix}';

    final bottomScrollPadding = widget.embedded
        ? AppBottomNav.barHeight + AppSpacing.xl
        : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final topChromeHeight = AppLayout.chromeTopHeight(
          context,
          barHeight: widget.embedded
              ? AppSizes.bookstoreTopHeaderHeight
              : AppSizes.topBarHeight,
        );
        final fixedTop = topChromeHeight + AppSizes.rankingStickyControlsTopGap;
        final segmentedTop = AppLayout.rankingScaledDesignY(
          width,
          AppSizes.rankingSegmentedFrameTop,
        );
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
        final headerHeight =
            segmentedTop +
            AppSizes.rankingSegmentedHeight +
            AppSizes.rankingSegmentedToBodyGap;
        final floatingSegmentedTop = (segmentedTop - _scrollOffset)
            .clamp(fixedTop, segmentedTop)
            .toDouble();
        final floatingRailTop = (headerHeight - _scrollOffset)
            .clamp(pinnedRailTop, headerHeight)
            .toDouble();

        return ColoredBox(
          color: AppColors.backgroundDark,
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _RankingScrollHeader(
                      title: title,
                      subtitle: dimension.subtitle,
                    ),
                  ),
                  _RankingBookSliverList(
                    books: books,
                    bottomScrollPadding: bottomScrollPadding,
                    onBookTap: AppRouter.goBookDetail,
                  ),
                ],
              ),
              Positioned(
                top: floatingSegmentedTop,
                left: segmentedLeft,
                width: segmentedWidth,
                child: RankingChannelSegmented(
                  selected: channel,
                  onSelected: cubit.selectChannel,
                ),
              ),
              Positioned(
                top: floatingRailTop,
                left: 0,
                child: RankingDimensionRail(
                  selected: dimension,
                  onSelected: cubit.selectDimension,
                ),
              ),
              if (!widget.embedded)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _RankingTopChrome(
                    statusBarHeight: statusBar,
                    blurEnabled: widget.topBlurEnabled,
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
                    showDivider: index > 0,
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
    required this.showDivider,
    required this.onTap,
  });

  final Book book;
  final int rank;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final row = RankingBookRow(book: book, rank: rank, onTap: onTap);
    if (!showDivider) return row;

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
  }
}

/// 可随列表滚动的头图 + 频道筛选区（Figma 1297:741）。
class _RankingScrollHeader extends StatelessWidget {
  const _RankingScrollHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final segmentedTop = AppLayout.rankingScaledDesignY(
          width,
          AppSizes.rankingSegmentedFrameTop,
        );
        final headerHeight =
            segmentedTop +
            AppSizes.rankingSegmentedHeight +
            AppSizes.rankingSegmentedToBodyGap;

        return SizedBox(
          height: headerHeight,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: RankingHeroBanner(title: title, subtitle: subtitle),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RankingTopChrome extends StatelessWidget {
  const _RankingTopChrome({
    required this.statusBarHeight,
    required this.blurEnabled,
  });

  final double statusBarHeight;
  final bool blurEnabled;

  static const String _searchIconAsset = 'assets/icons/search.svg';

  @override
  Widget build(BuildContext context) {
    return AppBlurredChromeBar(
      enabled: blurEnabled,
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: SizedBox(
          height: AppSizes.bookstoreTopHeaderHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const _RankingTopTabs(),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => AppRouter.pushNamed(AppRoutes.searchName),
                    behavior: HitTestBehavior.opaque,
                    child: const AppIcon(
                      assetPath: _searchIconAsset,
                      width: AppSizes.bookstoreSearchIconSize,
                      height: AppSizes.bookstoreSearchIconSize,
                      color: AppColors.textOnDarkMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RankingTopTabs extends StatelessWidget {
  const _RankingTopTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        _RankingTopTab(
          label: '推荐',
          style: AppTextStyles.tabInactiveDark,
          route: AppRoutes.home,
        ),
        SizedBox(width: AppSpacing.md),
        _RankingTopTab(
          label: '分类',
          style: AppTextStyles.tabInactiveDark,
          route: AppRoutes.category,
        ),
        SizedBox(width: AppSpacing.md),
        _RankingTopTab(label: '排行', style: AppTextStyles.tabActiveDark),
      ],
    );
  }
}

class _RankingTopTab extends StatelessWidget {
  const _RankingTopTab({required this.label, required this.style, this.route});

  final String label;
  final TextStyle style;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: route == null ? null : () => AppRouter.go(route!),
      behavior: HitTestBehavior.opaque,
      child: AppText(label, style: style),
    );
  }
}
