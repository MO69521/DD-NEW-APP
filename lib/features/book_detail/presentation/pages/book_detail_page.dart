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
import '../../../../shared/layouts/app_scroll_blur_scope.dart';
import '../../../../shared/widgets/app_button.dart';
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
import '../components/book_detail_quick_reply_sheet.dart';

/// 书籍详情页（Figma 183:1874）：仅渲染 state、触发 action。
class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

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
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('回复已发送')));
        }
        final quickReplyError = state.ui.quickReplyErrorMessage;
        if (state.ui.quickReplyErrorTick > 0 && quickReplyError != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(quickReplyError)));
        }
        final shelfToast = state.ui.shelfToastMessage;
        if (state.ui.shelfToastTick > 0 && shelfToast != null) {
          AppToast.show(context, shelfToast);
        }
      },
      child: BlocBuilder<BookDetailCubit, BookDetailState>(
        builder: (context, state) {
          if (state.ui.isLoading) {
            return const Scaffold(
              backgroundColor: AppColors.backgroundDark,
              body: Center(child: CircularProgressIndicator()),
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
            selectedTab: state.interaction.selectedTab,
            selectedDiscussionFilter:
                state.interaction.selectedDiscussionFilter,
            isInShelf: state.interaction.isInShelf,
            isGiftSent: state.interaction.isGiftSent,
          );
        },
      ),
    );
  }
}

class _BookDetailView extends StatefulWidget {
  const _BookDetailView({
    required this.detail,
    required this.selectedTab,
    required this.selectedDiscussionFilter,
    required this.isInShelf,
    required this.isGiftSent,
  });

  final BookDetail detail;
  final BookDetailTab selectedTab;
  final BookDiscussionFilter selectedDiscussionFilter;
  final bool isInShelf;
  final bool isGiftSent;

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
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label功能开发中')));
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
        AppRouter.pop();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('开始阅读：${chapter.title}')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookDetailCubit>();
    final statusBar = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      bottomNavigationBar: BookDetailBottomBar(
        isInShelf: widget.isInShelf,
        isGiftSent: widget.isGiftSent,
        giftCount: widget.detail.giftCount,
        onShelfTap: cubit.toggleShelf,
        onGiftTap: cubit.sendHeart,
        onReadTap: () => _comingSoon(context, '阅读器'),
      ),
      body: AppScrollBlurScope(
        builder: (context, topBlurEnabled) => Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              clipBehavior: Clip.none,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BookDetailHeroCover(coverAsset: widget.detail.coverAsset),
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
                      onTap: () => _comingSoon(context, '分享'),
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
