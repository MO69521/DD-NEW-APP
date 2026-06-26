import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/book.dart';
import '../data/datasources/book_detail_mock_datasource.dart';
import '../data/repositories/book_detail_repository_impl.dart';
import '../domain/entities/book_discussion_post.dart';
import '../domain/entities/book_discussion_filter.dart';
import '../domain/entities/book_detail_tab.dart';
import '../domain/repositories/book_detail_repository.dart';
import 'book_detail_domain_state.dart';
import 'book_detail_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class BookDetailCubit extends Cubit<BookDetailState> {
  BookDetailCubit({
    required this.bookId,
    this.seedBook,
    BookDetailRepository? repository,
  }) : _repository =
           repository ??
           const BookDetailRepositoryImpl(BookDetailMockDataSource()),
       super(const BookDetailState());

  final String bookId;

  /// 入口书卡携带的书籍，用于以真实封面/书名覆盖 mock 占位数据。
  final Book? seedBook;
  final BookDetailRepository _repository;

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
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          isInShelf: !state.interaction.isInShelf,
        ),
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
}
