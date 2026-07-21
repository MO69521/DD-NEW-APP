import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/layouts/app_scroll_blur_scope.dart';
import '../../../../shared/widgets/overscroll_stretch.dart';
import '../../application/book_detail_cubit.dart';
import '../../application/book_detail_state.dart';
import '../../domain/entities/book_discussion_filter.dart';
import '../../domain/entities/book_discussion_post.dart';
import '../../domain/entities/book_discussion_sort.dart';
import '../../domain/entities/book_detail.dart';
import '../../domain/entities/book_detail_tab.dart';
import '../components/book_detail_catalog_drawer.dart';
import '../components/book_detail_bottom_bar.dart';
import '../components/book_detail_content.dart';
import '../components/book_detail_hero_cover.dart';
import '../components/book_detail_promo_bar.dart';
import '../components/book_detail_quick_reply_sheet.dart';
import '../components/book_detail_status_views.dart';
import '../components/book_detail_top_bar.dart';
import '../components/book_detail_write_comment_fab.dart';

/// 书籍详情页（Figma 183:1874）：仅渲染 state、触发 action。
class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key, this.coverHeroTag});

  /// 入口书卡传入的封面 Hero 标签；缺省回退 `book-cover-<id>`。
  final Object? coverHeroTag;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookDetailCubit, BookDetailState>(
      listenWhen: (previous, current) =>
          previous.ui.quickReplySuccessTick !=
              current.ui.quickReplySuccessTick ||
          previous.ui.quickReplyErrorTick != current.ui.quickReplyErrorTick ||
          previous.ui.shelfToastTick != current.ui.shelfToastTick,
      listener: (context, state) {
        if (state.ui.quickReplySuccessTick > 0) {
          AppToast.show(context, '发送成功');
        }
        final quickReplyError = state.ui.quickReplyErrorMessage;
        if (state.ui.quickReplyErrorTick > 0 && quickReplyError != null) {
          AppToast.show(context, quickReplyError);
        }
        final shelfToast = state.ui.shelfToastMessage;
        if (state.ui.shelfToastTick > 0 && shelfToast != null) {
          AppToast.show(context, shelfToast);
        }
      },
      child: BlocBuilder<BookDetailCubit, BookDetailState>(
        builder: (context, state) {
          if (state.ui.isLoading) {
            final cubit = context.read<BookDetailCubit>();
            // 用入口书卡携带的封面即时渲染头图，让 Hero 飞行有落点；其余内容加载中。
            return BookDetailLoadingView(
              coverAsset: cubit.seedBook?.coverAsset,
              heroTag: coverHeroTag ?? 'book-cover-${cubit.bookId}',
            );
          }

          final detail = state.domain.detail;
          if (state.ui.errorMessage != null || detail == null) {
            return BookDetailErrorView(
              errorMessage: state.ui.errorMessage,
              onRetry: () => context.read<BookDetailCubit>().load(),
            );
          }

          return _BookDetailView(
            detail: detail,
            coverHeroTag: coverHeroTag,
            selectedTab: state.interaction.selectedTab,
            selectedDiscussionFilter:
                state.interaction.selectedDiscussionFilter,
            selectedDiscussionSort: state.interaction.selectedDiscussionSort,
            highlightedDiscussionPostId:
                state.ui.highlightedDiscussionPostId,
            isInShelf: state.interaction.isInShelf,
            isGiftSent: state.interaction.isGiftSent,
            isPromoDismissed: state.interaction.isPromoDismissed,
          );
        },
      ),
    );
  }
}

class _BookDetailView extends StatefulWidget {
  const _BookDetailView({
    required this.detail,
    required this.coverHeroTag,
    required this.selectedTab,
    required this.selectedDiscussionFilter,
    required this.selectedDiscussionSort,
    required this.highlightedDiscussionPostId,
    required this.isInShelf,
    required this.isGiftSent,
    required this.isPromoDismissed,
  });

  final BookDetail detail;
  final Object? coverHeroTag;
  final BookDetailTab selectedTab;
  final BookDiscussionFilter selectedDiscussionFilter;
  final BookDiscussionSort selectedDiscussionSort;
  final String? highlightedDiscussionPostId;
  final bool isInShelf;
  final bool isGiftSent;
  final bool isPromoDismissed;

  @override
  State<_BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<_BookDetailView> {
  late final ScrollController _scrollController;
  final GlobalKey _highlightedCommentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant _BookDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextId = widget.highlightedDiscussionPostId;
    if (nextId != null &&
        nextId != oldWidget.highlightedDiscussionPostId) {
      _scheduleScrollToHighlightedComment();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleScrollToHighlightedComment() {
    // 等弹层关闭 + 列表插入完成后再滚，连两帧避免布局未就绪。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final target = _highlightedCommentKey.currentContext;
        if (target == null) return;
        Scrollable.ensureVisible(
          target,
          duration: AppDurations.normal,
          curve: Curves.easeInOut,
          alignment: AppSizes.bookDetailNewCommentScrollAlignment,
        );
      });
    });
  }

  void _preserveScrollOffsetWhile(VoidCallback action) {
    if (!_scrollController.hasClients) {
      action();
      return;
    }

    final offset = _scrollController.offset;
    action();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final target = offset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      );
      if ((_scrollController.offset - target).abs() > AppSizes.hairline) {
        _scrollController.jumpTo(target);
      }
    });
  }

  void _comingSoon(BuildContext context, String label) {
    AppToast.show(context, '$label功能开发中');
  }

  /// 促销条文案用的角色名：优先取角色列表首位，缺省回退书名。
  String get _promoCharacterName {
    final characters = widget.detail.characters;
    if (characters.isNotEmpty && characters.first.name.trim().isNotEmpty) {
      return characters.first.name;
    }
    return widget.detail.title;
  }

  Future<void> _openQuickReply(
    BuildContext context,
    BookDiscussionPost post,
  ) async {
    final text = await BookDetailQuickReplySheet.show(
      context,
      authorName: post.authorName,
    );
    if (!context.mounted || text == null || text.trim().isEmpty) return;
    await context.read<BookDetailCubit>().submitQuickReply(
      postId: post.id,
      content: text,
    );
  }

  Future<void> _openWriteComment(BuildContext context) async {
    final text = await BookDetailQuickReplySheet.show(
      context,
      title: '写评论',
    );
    if (!context.mounted || text == null || text.trim().isEmpty) return;
    await context.read<BookDetailCubit>().submitDiscussionComment(text);
  }

  void _openCatalog(BuildContext context) {
    BookDetailCatalogDrawer.show(
      context,
      detail: widget.detail,
      onChapterTap: (chapter) {
        if (chapter.isLocked) {
          AppToast.show(context, '读完前一张即可解锁');
          return;
        }
        AppToast.show(context, '开始阅读：${chapter.title}');
        AppRouter.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookDetailCubit>();
    final statusBar = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.bookDetailPageBackground,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isPromoDismissed)
            BookDetailPromoBar(
              title: '打开腾讯元宝生成专属$_promoCharacterName',
              onClaim: cubit.claimPromo,
              onClose: cubit.dismissPromo,
            ),
          BookDetailBottomBar(
            isInShelf: widget.isInShelf,
            isGiftSent: widget.isGiftSent,
            giftCount: widget.detail.giftCount,
            onShelfTap: cubit.toggleShelf,
            onGiftTap: cubit.sendHeart,
            onReadTap: () => _comingSoon(context, '阅读器'),
          ),
        ],
      ),
      body: AppScrollBlurScope(
        builder: (context, topBlurEnabled) => Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OverscrollStretch(
                        controller: _scrollController,
                        baseHeight:
                            MediaQuery.sizeOf(context).width /
                            AppSizes.bookDetailHeroAspectRatio,
                        child: BookDetailHeroCover(
                          coverAsset: widget.detail.coverAsset,
                          heroTag:
                              widget.coverHeroTag ??
                              'book-cover-${widget.detail.id}',
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.bookDetailContentHeroOverlap,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.bookDetailContentHInset,
                        ),
                        child: BookDetailContent(
                          detail: widget.detail,
                          selectedTab: widget.selectedTab,
                          selectedDiscussionFilter:
                              widget.selectedDiscussionFilter,
                          selectedDiscussionSort:
                              widget.selectedDiscussionSort,
                          highlightedDiscussionPostId:
                              widget.highlightedDiscussionPostId,
                          highlightedCommentKey: _highlightedCommentKey,
                          onTabSelected: cubit.switchTab,
                          onDiscussionFilterSelected: (filter) =>
                              _preserveScrollOffsetWhile(
                                () => cubit.switchDiscussionFilter(filter),
                              ),
                          onDiscussionSortSelected: (sort) =>
                              _preserveScrollOffsetWhile(
                                () => cubit.switchDiscussionSort(sort),
                              ),
                          onDiscussionPostTap: (post) =>
                              AppRouter.pushBookDiscussionDetail(
                                bookId: widget.detail.id,
                                post: post,
                              ),
                          onDiscussionPostLikeTap: (post) =>
                              cubit.toggleDiscussionPostLike(post.id),
                          onDiscussionPostBodyTap: (post) =>
                              _openQuickReply(context, post),
                          onCatalogTap: () => _openCatalog(context),
                          onCharacterFavTap: (_) =>
                              _comingSoon(context, '收藏和表白'),
                          onRecommendationRefreshTap:
                              cubit.refreshRecommendations,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            BookDetailTopBar(
              statusBarHeight: statusBar,
              blurEnabled: topBlurEnabled,
              title: widget.detail.title,
            ),
            if (widget.selectedTab == BookDetailTab.discussion)
              BookDetailWriteCommentFab(
                hasPromoBar: !widget.isPromoDismissed,
                onTap: () => _openWriteComment(context),
              ),
          ],
        ),
      ),
    );
  }
}
