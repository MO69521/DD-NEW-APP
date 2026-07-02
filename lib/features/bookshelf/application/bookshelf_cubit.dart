import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/bookshelf_membership_service.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/domain/entities/book.dart';
import '../data/datasources/bookshelf_mock_datasource.dart';
import '../data/repositories/bookshelf_repository_impl.dart';
import '../domain/entities/bookshelf_page_content.dart';
import '../domain/entities/bookshelf_tab.dart';
import '../domain/repositories/bookshelf_repository.dart';
import 'bookshelf_domain_state.dart';
import 'bookshelf_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class BookshelfCubit extends Cubit<BookshelfState> {
  BookshelfCubit({
    BookshelfRepository? repository,
    BookshelfMembershipService? membershipService,
  }) : _repository =
           repository ??
           const BookshelfRepositoryImpl(BookshelfMockDataSource()),
       _membershipService =
           membershipService ?? ServiceLocator.bookshelfMembership,
       super(const BookshelfState()) {
    _membershipSubscription = _membershipService.booksStream.listen(
      _syncShelfBooks,
    );
  }

  final BookshelfRepository _repository;
  final BookshelfMembershipService _membershipService;
  late final StreamSubscription<List<Book>> _membershipSubscription;

  Future<void> load() async {
    emit(
      state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)),
    );

    try {
      final content = await _repository.fetchPageContent();
      _membershipService.initializeIfNeeded(
        content.booksFor(BookshelfTab.shelf),
      );
      final syncedContent = _contentWithShelfBooks(
        content,
        _membershipService.books,
      );
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: BookshelfDomainState(content: syncedContent),
          recommendationBooks: List.unmodifiable(content.recommendationBooks),
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

  void switchTab(BookshelfTab tab) {
    if (tab == state.interaction.selectedTab) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          selectedTab: tab,
          isManaging: false,
          selectedBookIds: const {},
        ),
      ),
    );
  }

  /// 管理入口：退出时清空本次选择，避免下次进入残留。
  void onManageTap() {
    final nextManaging = !state.interaction.isManaging;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          isManaging: nextManaging,
          selectedBookIds: nextManaging
              ? state.interaction.selectedBookIds
              : const {},
        ),
      ),
    );
  }

  void toggleBookSelection(Book book) {
    if (!state.interaction.isManaging) return;
    if (state.interaction.selectedTab != BookshelfTab.shelf) return;

    final selected = Set<String>.of(state.interaction.selectedBookIds);
    if (selected.contains(book.id)) {
      selected.remove(book.id);
    } else {
      selected.add(book.id);
    }

    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          selectedBookIds: Set.unmodifiable(selected),
        ),
      ),
    );
  }

  void toggleSelectAll() {
    if (!state.interaction.isManaging) return;
    if (state.interaction.selectedTab != BookshelfTab.shelf) return;

    final shelfBookIds = state.domain
        .bookSeedFor(BookshelfTab.shelf)
        .map((book) => book.id)
        .toSet();
    final shouldSelectAll =
        state.interaction.selectedBookIds.length != shelfBookIds.length;

    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          selectedBookIds: shouldSelectAll
              ? Set.unmodifiable(shelfBookIds)
              : const {},
        ),
      ),
    );
  }

  void deleteSelectedBooks() {
    final selectedIds = state.interaction.selectedBookIds;
    if (selectedIds.isEmpty) return;

    _membershipService.removeAll(selectedIds);
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedBookIds: const {}),
      ),
    );
  }

  void onScrollNearEnd(double extentAfter) {
    if (state.ui.isLoadingMore) return;
    if (state.interaction.selectedTab != BookshelfTab.shelf) return;

    final seed = state.domain.recommendationSeed;
    if (seed.isEmpty) return;

    if (extentAfter <= AppSizes.bookstoreLoadMoreTriggerOffset) {
      loadMoreRecommendations();
    }
  }

  Future<void> loadMoreRecommendations() async {
    if (state.interaction.selectedTab != BookshelfTab.shelf) return;

    final seed = state.domain.recommendationSeed;
    if (state.ui.isLoadingMore || seed.isEmpty) return;

    emit(state.copyWith(ui: state.ui.copyWith(isLoadingMore: true)));
    await Future<void>.delayed(AppDurations.normal);

    final nextPage = state.ui.recommendationPage + 1;
    final offset = nextPage * seed.length;
    final moreBooks = List<Book>.generate(seed.length, (index) {
      final source = seed[index];
      final newIndex = offset + index + 1;
      return Book(
        id: 'bookshelf_rec_more_$newIndex',
        title: source.title,
        category: source.category,
        coverAsset: source.coverAsset,
        summary: source.summary,
        annotations: source.annotations,
        coverTag: source.coverTag,
      );
    });

    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          isLoadingMore: false,
          recommendationPage: nextPage,
        ),
        recommendationBooks: List.unmodifiable([
          ...state.recommendationBooks,
          ...moreBooks,
        ]),
      ),
    );
  }

  void _syncShelfBooks(List<Book> shelfBooks) {
    final content = state.domain.content;
    if (content == null) return;

    final nextContent = _contentWithShelfBooks(content, shelfBooks);
    final nextShelfIds = shelfBooks.map((book) => book.id).toSet();
    final nextSelectedIds = state.interaction.selectedBookIds
        .where(nextShelfIds.contains)
        .toSet();

    final shelfChanged = !_sameBookIds(
      content.booksFor(BookshelfTab.shelf),
      shelfBooks,
    );
    final selectionChanged =
        nextSelectedIds.length != state.interaction.selectedBookIds.length;

    if (!shelfChanged && !selectionChanged) return;

    emit(
      state.copyWith(
        domain: shelfChanged
            ? state.domain.copyWith(content: nextContent)
            : state.domain,
        interaction: selectionChanged
            ? state.interaction.copyWith(
                selectedBookIds: Set.unmodifiable(nextSelectedIds),
              )
            : state.interaction,
      ),
    );
  }

  BookshelfPageContent _contentWithShelfBooks(
    BookshelfPageContent content,
    List<Book> shelfBooks,
  ) {
    return content.copyWith(
      booksByTab: {
        ...content.booksByTab,
        BookshelfTab.shelf: List.unmodifiable(shelfBooks),
      },
    );
  }

  bool _sameBookIds(List<Book> a, List<Book> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  Future<void> close() {
    _membershipSubscription.cancel();
    return super.close();
  }
}
