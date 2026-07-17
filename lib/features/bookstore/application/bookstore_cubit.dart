import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/api_env.dart';
import '../../../core/domain/entities/book.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_sizes.dart';
import '../data/datasources/bookstore_mock_datasource.dart';
import '../data/datasources/bookstore_remote_datasource.dart';
import '../data/repositories/bookstore_repository_impl.dart';
import '../domain/entities/bookstore_top_tab.dart';
import '../domain/repositories/bookstore_repository.dart';
import 'bookstore_domain_state.dart';
import 'bookstore_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class BookstoreCubit extends Cubit<BookstoreState> {
  BookstoreCubit({BookstoreRepository? repository})
    : _repository = repository ?? _defaultRepository(),
      super(const BookstoreState());

  final BookstoreRepository _repository;
  Future<void>? _refreshFuture;

  /// 默认仓储：`API_ENV=rest` 时用真实接口，否则用 Mock（无后端时默认）。
  static BookstoreRepository _defaultRepository() {
    return BookstoreRepositoryImpl(
      ApiEnvConfig.isRest
          ? BookstoreRemoteDataSource(ServiceLocator.apiClient)
          : BookstoreMockDataSource(),
    );
  }

  Future<void> load() async {
    emit(
      state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)),
    );

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: BookstoreDomainState(content: content),
          guessLikeBooks: List.unmodifiable(content.guessLikeBooks),
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

  /// 保留当前页面内容执行刷新，避免复用首次加载态造成整页闪屏。
  Future<void> refresh() {
    return _refreshFuture ??= _refreshContent().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<void> _refreshContent() async {
    emit(state.copyWith(ui: state.ui.copyWith(isRefreshing: true)));
    // 刷新动画单轮为 0.8 秒；快速请求也至少完整播放两轮后再释放占位。
    final refreshAnimationCycle = AppDurations.slow + AppDurations.normal;
    final minimumVisibleFuture = Future<void>.delayed(
      refreshAnimationCycle * 2,
    );

    try {
      final content = await _repository.fetchPageContent();
      await minimumVisibleFuture;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isRefreshing: false,
            guessLikePage: 0,
            clearError: true,
          ),
          domain: BookstoreDomainState(content: content),
          guessLikeBooks: List.unmodifiable(content.guessLikeBooks),
        ),
      );
    } catch (_) {
      await minimumVisibleFuture;
      emit(state.copyWith(ui: state.ui.copyWith(isRefreshing: false)));
      rethrow;
    }
  }

  void switchTopTab(BookstoreTopTab tab) {
    if (tab == state.interaction.selectedTopTab) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedTopTab: tab),
      ),
    );
  }

  void dismissContinueReading() {
    if (state.interaction.continueReadingDismissed) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(continueReadingDismissed: true),
      ),
    );
  }

  void switchRankingTab(RankingTab tab) {
    if (tab == state.interaction.selectedRankingTab) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedRankingTab: tab),
      ),
    );
  }

  void onScrollNearEnd(double pixels, double maxScrollExtent) {
    if (maxScrollExtent <= 0) return;
    final triggerOffset =
        maxScrollExtent - AppSizes.bookstoreLoadMoreTriggerOffset;
    if (pixels >= triggerOffset) {
      loadMoreGuessLike();
    }
  }

  Future<void> loadMoreGuessLike() async {
    final seed = state.domain.guessLikeSeed;
    if (state.ui.isLoadingMoreGuessLike || seed.isEmpty) return;

    emit(state.copyWith(ui: state.ui.copyWith(isLoadingMoreGuessLike: true)));
    await Future<void>.delayed(AppDurations.normal);

    final nextPage = state.ui.guessLikePage + 1;
    final offset = nextPage * seed.length;
    final moreBooks = List<Book>.generate(seed.length, (index) {
      final source = seed[index];
      final newIndex = offset + index + 1;
      return Book(
        id: 'g_more_$newIndex',
        title: source.title,
        category: source.category,
        coverAsset: source.coverAsset,
        coverTag: source.coverTag,
      );
    });

    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          isLoadingMoreGuessLike: false,
          guessLikePage: nextPage,
        ),
        guessLikeBooks: List.unmodifiable([
          ...state.guessLikeBooks,
          ...moreBooks,
        ]),
      ),
    );
  }
}
