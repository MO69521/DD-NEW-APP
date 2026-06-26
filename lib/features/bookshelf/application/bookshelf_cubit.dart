import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../../core/domain/entities/book.dart';
import '../data/datasources/bookshelf_mock_datasource.dart';
import '../data/repositories/bookshelf_repository_impl.dart';
import '../domain/entities/bookshelf_tab.dart';
import '../domain/repositories/bookshelf_repository.dart';
import 'bookshelf_domain_state.dart';
import 'bookshelf_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class BookshelfCubit extends Cubit<BookshelfState> {
  BookshelfCubit({BookshelfRepository? repository})
    : _repository = repository ??
          const BookshelfRepositoryImpl(BookshelfMockDataSource()),
      super(const BookshelfState());

  final BookshelfRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)));

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: BookshelfDomainState(content: content),
          paginatedBooksByTab: {
            for (final tab in BookshelfTab.values)
              tab: List.unmodifiable(content.booksFor(tab)),
          },
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
        interaction: state.interaction.copyWith(selectedTab: tab),
      ),
    );
  }

  /// 管理入口：现阶段仅占位切换状态，后续可驱动多选 / 删除 UI。
  void onManageTap() {
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          isManaging: !state.interaction.isManaging,
        ),
      ),
    );
  }

  void onScrollNearEnd(double extentAfter) {
    if (state.ui.isLoadingMore) return;

    final tab = state.interaction.selectedTab;
    if (state.domain.bookSeedFor(tab).isEmpty) return;

    if (extentAfter <= AppSizes.bookstoreLoadMoreTriggerOffset) {
      loadMoreBooks();
    }
  }

  Future<void> loadMoreBooks() async {
    final tab = state.interaction.selectedTab;
    final seed = state.domain.bookSeedFor(tab);
    if (state.ui.isLoadingMore || seed.isEmpty) return;

    emit(state.copyWith(ui: state.ui.copyWith(isLoadingMore: true)));
    await Future<void>.delayed(AppDurations.normal);

    final nextPage = (state.ui.loadMorePageByTab[tab] ?? 0) + 1;
    final offset = nextPage * seed.length;
    final idPrefix = tab == BookshelfTab.shelf ? 's' : 'h';
    final moreBooks = List<Book>.generate(seed.length, (index) {
      final source = seed[index];
      final newIndex = offset + index + 1;
      return Book(
        id: '${idPrefix}_more_$newIndex',
        title: source.title,
        category: source.category,
        coverAsset: source.coverAsset,
      );
    });

    final currentBooks =
        state.paginatedBooksByTab[tab] ?? List.unmodifiable(seed);

    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          isLoadingMore: false,
          loadMorePageByTab: {
            ...state.ui.loadMorePageByTab,
            tab: nextPage,
          },
        ),
        paginatedBooksByTab: {
          ...state.paginatedBooksByTab,
          tab: List.unmodifiable([...currentBooks, ...moreBooks]),
        },
      ),
    );
  }
}
