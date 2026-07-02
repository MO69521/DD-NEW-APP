import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/book.dart';
import '../../../core/services/bookshelf_membership_service.dart';
import '../../../core/services/service_locator.dart';
import '../data/datasources/book_detail_mock_datasource.dart';
import '../data/repositories/book_detail_repository_impl.dart';
import '../domain/entities/book_detail.dart';
import '../domain/entities/book_discussion_post.dart';
import '../domain/entities/book_discussion_filter.dart';
import '../domain/entities/book_detail_tab.dart';
import '../domain/repositories/book_detail_repository.dart';
import 'book_detail_domain_state.dart';
import 'book_detail_interaction_state.dart';
import 'book_detail_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class BookDetailCubit extends Cubit<BookDetailState> {
  BookDetailCubit({
    required this.bookId,
    this.seedBook,
    this.initialIsInShelf = false,
    BookDetailRepository? repository,
    BookshelfMembershipService? membershipService,
  }) : _repository =
           repository ??
           const BookDetailRepositoryImpl(BookDetailMockDataSource()),
       _membershipService =
           membershipService ?? ServiceLocator.bookshelfMembership,
       super(
         BookDetailState(
           interaction: BookDetailInteractionState(isInShelf: initialIsInShelf),
         ),
       ) {
    final seed = seedBook;
    if (initialIsInShelf && seed != null) {
      _membershipService.add(seed);
    }
    _fallbackIsInShelf =
        initialIsInShelf &&
        seed == null &&
        !_membershipService.contains(bookId);
    _syncShelfState();
    _membershipSubscription = _membershipService.booksStream.listen(
      (_) => _syncShelfState(),
    );
  }

  final String bookId;

  /// 入口书卡携带的书籍，用于以真实封面/书名覆盖 mock 占位数据。
  final Book? seedBook;
  final bool initialIsInShelf;
  final BookDetailRepository _repository;
  final BookshelfMembershipService _membershipService;
  late final StreamSubscription<List<Book>> _membershipSubscription;
  late bool _fallbackIsInShelf;

  Future<void> load() async {
    emit(
      state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)),
    );

    try {
      final detail = await _repository.fetchDetail(bookId);
      final seed = seedBook;
      final merged = seed == null
          ? detail
          : detail.copyWith(title: seed.title, coverAsset: seed.coverAsset);
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: BookDetailDomainState(detail: merged),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          ),
        ),
      );
    }
  }

  void switchTab(BookDetailTab tab) {
    if (tab == state.interaction.selectedTab) return;
    emit(
      state.copyWith(interaction: state.interaction.copyWith(selectedTab: tab)),
    );
  }

  void switchDiscussionFilter(BookDiscussionFilter filter) {
    if (filter == state.interaction.selectedDiscussionFilter) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          selectedDiscussionFilter: filter,
        ),
      ),
    );
  }

  void toggleShelf() {
    if (state.interaction.isInShelf) {
      _fallbackIsInShelf = false;
      _membershipService.remove(bookId);
      _syncShelfState();
      _emitShelfToast('已取消加入书架');
      return;
    }

    final book = _bookForShelf();
    if (book == null) return;
    _membershipService.add(book);
    _emitShelfToast('加入成功');
  }

  void _emitShelfToast(String message) {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          shelfToastTick: state.ui.shelfToastTick + 1,
          shelfToastMessage: message,
        ),
      ),
    );
  }

  Book? _bookForShelf() {
    final seed = seedBook;
    if (seed != null) return seed;

    final detail = state.domain.detail;
    if (detail == null) return null;
    return detail.toBook();
  }

  void _syncShelfState() {
    final nextIsInShelf =
        _fallbackIsInShelf || _membershipService.contains(bookId);
    if (nextIsInShelf == state.interaction.isInShelf) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(isInShelf: nextIsInShelf),
      ),
    );
  }

  void toggleDiscussionPostLike(String postId) {
    final detail = state.domain.detail;
    if (detail == null) return;

    final nextPosts = detail.discussionPosts
        .map((post) => _toggleLikeForPost(post, postId))
        .toList(growable: false);
    emit(
      state.copyWith(
        domain: state.domain.copyWith(
          detail: detail.copyWith(discussionPosts: nextPosts),
        ),
      ),
    );
  }

  void refreshRecommendations() {
    final detail = state.domain.detail;
    final books = detail?.recommendedBooks;
    if (detail == null || books == null || books.length < 2) return;

    final nextBooks = [...books.skip(1), books.first];
    emit(
      state.copyWith(
        domain: state.domain.copyWith(
          detail: detail.copyWith(recommendedBooks: nextBooks),
        ),
      ),
    );
  }

  BookDiscussionPost _toggleLikeForPost(
    BookDiscussionPost post,
    String postId,
  ) {
    if (post.id != postId) return post;
    final nextLiked = !post.isLiked;
    final nextCount = nextLiked ? post.likeCount + 1 : post.likeCount - 1;
    return post.copyWith(
      isLiked: nextLiked,
      likeCount: nextCount < 0 ? 0 : nextCount,
    );
  }

  Future<void> submitQuickReply({
    required String postId,
    required String content,
  }) async {
    final text = content.trim();
    if (text.isEmpty) {
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            quickReplyErrorTick: state.ui.quickReplyErrorTick + 1,
            quickReplyErrorMessage: '回复内容不能为空',
          ),
        ),
      );
      return;
    }

    final detail = state.domain.detail;
    if (detail == null) return;

    final nextPosts = detail.discussionPosts
        .map((post) {
          if (post.id != postId) return post;
          return post.copyWith(
            replyCount: post.replyCount + 1,
            replyPreview: BookDiscussionReplyPreview(
              authorName: '我',
              content: text,
            ),
          );
        })
        .toList(growable: false);

    emit(
      state.copyWith(
        domain: state.domain.copyWith(
          detail: detail.copyWith(discussionPosts: nextPosts),
        ),
        ui: state.ui.copyWith(
          quickReplySuccessTick: state.ui.quickReplySuccessTick + 1,
          clearQuickReplyError: true,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _membershipSubscription.cancel();
    return super.close();
  }
}

extension on BookDetail {
  Book toBook() {
    return Book(
      id: id,
      title: title,
      category: tags.join(' · '),
      coverAsset: coverAsset,
      summary: intro,
      annotations: tags,
    );
  }
}
