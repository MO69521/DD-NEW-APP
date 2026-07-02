import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/layouts/app_scroll_blur_scope.dart';
import '../../domain/entities/ranking_channel.dart';
import '../../application/ranking_cubit.dart';
import '../../application/ranking_state.dart';
import 'ranking_book_list.dart';
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
  bool _controlsPinned = false;
  double _pinThreshold = 0;

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
    _updateControlsPinned(_scrollController.offset);
  }

  void _updateControlsPinned(double scrollOffset) {
    final nextPinned = scrollOffset >= _pinThreshold;
    if (nextPinned != _controlsPinned && mounted) {
      setState(() => _controlsPinned = nextPinned);
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final scrollOffset =
        notification.metrics.pixels > notification.metrics.extentBefore
        ? notification.metrics.pixels
        : notification.metrics.extentBefore;
    _updateControlsPinned(scrollOffset);
    return false;
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
        final headerTopInset = widget.embedded ? 0.0 : topChromeHeight;
        final segmentedTop =
            headerTopInset +
            AppLayout.rankingScaledDesignY(
              width,
              AppSizes.rankingSegmentedFrameTop,
            );
        _pinThreshold = segmentedTop - topChromeHeight;
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

        return NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: ColoredBox(
            color: AppColors.backgroundDark,
            child: Stack(
              children: [
                NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: _RankingScrollHeader(
                        title: title,
                        subtitle: dimension.subtitle,
                        selectedChannel: channel,
                        onChannelSelected: cubit.selectChannel,
                        showSegmented: !_controlsPinned,
                        topInset: headerTopInset,
                      ),
                    ),
                  ],
                  body: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: !_controlsPinned,
                        maintainSize: true,
                        maintainState: true,
                        maintainAnimation: true,
                        child: RankingDimensionRail(
                          selected: dimension,
                          onSelected: cubit.selectDimension,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: RankingBookList(
                          books: books,
                          bottomScrollPadding: bottomScrollPadding,
                          onBookTap: AppRouter.goBookDetail,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_controlsPinned) ...[
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
                ],
                if (!widget.embedded)
                  Positioned(
                    top: statusBar,
                    left: 0,
                    right: 0,
                    child: AppBlurredChromeBar(
                      enabled: widget.topBlurEnabled,
                      child: AppTopBar(
                        onBack: () => AppRouter.pop(),
                        actions: [
                          AppTopBarAction(
                            iconAsset: 'assets/icons/ranking/share.svg',
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 可随列表滚动的头图 + 频道筛选区（Figma 1297:741）。
class _RankingScrollHeader extends StatelessWidget {
  const _RankingScrollHeader({
    required this.title,
    required this.subtitle,
    required this.selectedChannel,
    required this.onChannelSelected,
    required this.showSegmented,
    required this.topInset,
  });

  final String title;
  final String subtitle;
  final RankingChannel selectedChannel;
  final ValueChanged<RankingChannel> onChannelSelected;
  final bool showSegmented;
  final double topInset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final segmentedTop =
            topInset +
            AppLayout.rankingScaledDesignY(
              width,
              AppSizes.rankingSegmentedFrameTop,
            );
        final headerHeight =
            segmentedTop +
            AppSizes.rankingSegmentedHeight +
            AppSizes.rankingSegmentedToBodyGap;
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

        return SizedBox(
          height: headerHeight,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                top: topInset,
                left: 0,
                right: 0,
                child: RankingHeroBanner(title: title, subtitle: subtitle),
              ),
              if (showSegmented)
                Positioned(
                  top: segmentedTop,
                  left: segmentedLeft,
                  width: segmentedWidth,
                  child: RankingChannelSegmented(
                    selected: selectedChannel,
                    onSelected: onChannelSelected,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
