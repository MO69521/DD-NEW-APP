import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/components/book_card_skeletons.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/search_cubit.dart';
import '../../application/search_domain_state.dart';
import '../../application/search_state.dart';
import '../../application/search_ui_state.dart';
import '../../domain/entities/search_suggestion.dart';
import '../components/search_app_bar.dart';
import '../components/search_clear_history_dialog.dart';
import '../components/search_keyword_section.dart';
import '../components/search_recommendation_row.dart';
import '../components/search_result_list.dart';
import '../components/search_suggestion_list.dart';

/// 搜索页（深色态）：仅渲染 state、触发 action。
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  static const String _placeholder = '多个关键词用空格隔开';
  static const String _emptyCaption = '搜索您想要的作品吧';
  static const String _noResultTitle = '没有找到相关作品';
  static const String _noResultDescription = '换个关键词试试吧';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final cubit = context.read<SearchCubit>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      resizeToAvoidBottomInset: false,
      body: AppPageChrome(
        topBar: SearchAppBar(
          statusBarHeight: statusBarHeight,
          placeholder: _placeholder,
          onBack: AppRouter.pop,
          onSubmit: cubit.search,
          onChanged: cubit.queryChanged,
        ),
        // 转场期间只滑入轻量空底，图片列表 / 骨架待滑入完成后再构建，
        // 避免首帧重绘与 push 动画抢帧导致的卡顿。
        body: const _TransitionGate(child: _SearchBody()),
      ),
    );
  }
}

/// 门控：路由 push 转场结束后再构建 [child]，转场期间只渲染轻量占位。
class _TransitionGate extends StatefulWidget {
  const _TransitionGate({required this.child});

  final Widget child;

  @override
  State<_TransitionGate> createState() => _TransitionGateState();
}

class _TransitionGateState extends State<_TransitionGate> {
  bool _ready = false;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _gateOnTransition());
  }

  void _gateOnTransition() {
    if (!mounted) return;
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null || animation.isCompleted) {
      setState(() => _ready = true);
      return;
    }
    _animation = animation..addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _animation?.removeStatusListener(_onStatus);
    _animation = null;
    if (mounted) setState(() => _ready = true);
  }

  @override
  void dispose() {
    _animation?.removeStatusListener(_onStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SizedBox.expand();
    return widget.child;
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollStartNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        return false;
      },
      child: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (previous, current) =>
            previous.ui != current.ui ||
            previous.domain != current.domain ||
            previous.interaction != current.interaction,
        builder: (context, state) {
          switch (state.ui.phase) {
            case SearchPhase.suggesting:
              return _SuggestionList(
                suggestions: state.domain.suggestions,
                query: state.interaction.committedQuery,
              );
            case SearchPhase.loading:
              return BookLargeRowListSkeleton(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppLayout.chromeTopHeight(context) + AppSpacing.md,
                  AppSpacing.md,
                  0,
                ),
              );
            case SearchPhase.results:
              return _ResultList(domain: state.domain);
            case SearchPhase.noResult:
              return const EmptyState(
                title: SearchPage._noResultTitle,
                description: SearchPage._noResultDescription,
              );
            case SearchPhase.empty:
              return _EmptyBody(
                domain: state.domain,
                isRecommendationsLoading: state.ui.isRecommendationsLoading,
                emptyCaption: SearchPage._emptyCaption,
              );
          }
        },
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.domain});

  final SearchDomainState domain;

  @override
  Widget build(BuildContext context) {
    final membership = ServiceLocator.bookshelfMembership;
    return StreamBuilder<List<Book>>(
      stream: membership.booksStream,
      initialData: membership.books,
      builder: (context, snapshot) {
        final inShelfBookIds = {
          for (final book in snapshot.data ?? const <Book>[]) book.id,
        };
        return SearchResultList(
          items: domain.results,
          inShelfBookIds: inShelfBookIds,
          onItemTap: AppRouter.goBookDetail,
          onAddToShelf: (book) {
            if (membership.contains(book.id)) {
              membership.remove(book.id);
              AppToast.show(context, '已取消加入书架');
            } else {
              membership.add(book);
              AppToast.show(context, '加入成功');
            }
          },
        );
      },
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({required this.suggestions, required this.query});

  final List<SearchSuggestion> suggestions;
  final String query;

  @override
  Widget build(BuildContext context) {
    return SearchSuggestionList(
      suggestions: suggestions,
      query: query,
      onSelect: context.read<SearchCubit>().search,
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
        _ => AppColors.white60,
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

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({
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
      cubit.clearHistory();
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
