import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/components/share_bottom_sheet.dart';
import '../../../../shared/layouts/app_scroll_blur_scope.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/overscroll_stretch.dart';
import '../../application/book_detail_cubit.dart';
import '../../application/book_detail_state.dart';
import '../../domain/entities/book_discussion_filter.dart';
import '../../domain/entities/book_discussion_post.dart';
import '../../domain/entities/book_detail.dart';
import '../../domain/entities/book_detail_tab.dart';
import '../components/book_detail_catalog_drawer.dart';
import '../components/book_detail_bottom_bar.dart';
import '../components/book_detail_content.dart';
import '../components/book_detail_hero_cover.dart';
import '../components/book_detail_promo_bar.dart';
import '../components/book_detail_quick_reply_sheet.dart';

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
          AppToast.show(context, '回复已发送');
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
            final seed = cubit.seedBook;
            if (seed == null) {
              return const Scaffold(
                backgroundColor: AppColors.backgroundDark,
                body: Center(child: CircularProgressIndicator()),
              );
            }
            // 用入口书卡携带的封面即时渲染头图，让 Hero 飞行有落点；其余内容加载中。
            return Scaffold(
              backgroundColor: AppColors.backgroundDark,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BookDetailHeroCover(
                    coverAsset: seed.coverAsset,
                    heroTag: coverHeroTag ?? 'book-cover-${cubit.bookId}',
                  ),
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            );
          }

          final detail = state.domain.detail;
          if (state.ui.errorMessage != null || detail == null) {
            return Scaffold(
              backgroundColor: AppColors.backgroundDark,
              body: EmptyState(
                title: '加载失败',
                description: state.ui.errorMessage,
                action: AppButton(
                  label: '重试',
                  onPressed: () => context.read<BookDetailCubit>().load(),
                ),
              ),
            );
          }

          return _BookDetailView(
            detail: detail,
            coverHeroTag: coverHeroTag,
            selectedTab: state.interaction.selectedTab,
            selectedDiscussionFilter:
                state.interaction.selectedDiscussionFilter,
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
    required this.isInShelf,
    required this.isGiftSent,
    required this.isPromoDismissed,
  });

  final BookDetail detail;
  final Object? coverHeroTag;
  final BookDetailTab selectedTab;
  final BookDiscussionFilter selectedDiscussionFilter;
  final bool isInShelf;
  final bool isGiftSent;
  final bool isPromoDismissed;

  @override
  State<_BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<_BookDetailView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    context.read<BookDetailCubit>().submitQuickReply(
      postId: post.id,
      content: text,
    );
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
      backgroundColor: AppColors.backgroundDark,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isPromoDismissed)
            BookDetailPromoBar(
              title: '打开腾讯元宝生成专属${_promoCharacterName}',
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
                          onTabSelected: cubit.switchTab,
                          onDiscussionFilterSelected: (filter) =>
                              _preserveScrollOffsetWhile(
                                () => cubit.switchDiscussionFilter(filter),
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBlurredChromeBar(
                enabled: topBlurEnabled,
                child: AppTopBar(
                  statusBarHeight: statusBar,
                  title: topBlurEnabled ? widget.detail.title : null,
                  showScrim: true,
                  chromeBlurEnabled: false,
                  onBack: () => AppRouter.pop(),
                  actions: [
                    AppTopBarAction(
                      iconAsset: 'assets/icons/ranking/share.svg',
                      onTap: () => ShareBottomSheet.show(
                        context,
                        onChannelTap: (channel) =>
                            AppToast.show(context, '分享到$channel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
