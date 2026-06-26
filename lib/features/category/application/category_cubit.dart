import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../../core/domain/entities/book.dart';
import '../data/datasources/category_mock_datasource.dart';
import '../data/repositories/category_repository_impl.dart';
import '../domain/entities/category_book_item.dart';
import '../domain/repositories/category_repository.dart';
import 'category_domain_state.dart';
import 'category_interaction_state.dart';
import 'category_state.dart';
import 'category_ui_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({CategoryRepository? repository})
      : _repository = repository ??
            const CategoryRepositoryImpl(CategoryMockDataSource()),
        super(const CategoryState());

  final CategoryRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(phase: CategoryPhase.loading, clearError: true),
      ),
    );

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            phase: content.items.isEmpty
                ? CategoryPhase.empty
                : CategoryPhase.loaded,
          ),
          domain: CategoryDomainState(
            filterGroups: content.filterGroups,
            seedItems: content.items,
            items: content.items,
          ),
          interaction: CategoryInteractionState(
            selectedIndices: {
              for (final group in content.filterGroups) group.id: 0,
            },
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            phase: CategoryPhase.empty,
            errorMessage: error.toString(),
          ),
        ),
      );
    }
  }

  /// 选中某筛选组的某项。Phase 1 仅更新选中态，结果集保持静态。
  void selectOption(String groupId, int index) {
    if (state.interaction.selectedIndexFor(groupId) == index) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          selectedIndices: {
            ...state.interaction.selectedIndices,
            groupId: index,
          },
        ),
      ),
    );
  }

  /// 滚动接近底部时触发上拉加载更多。
  void onScrollNearEnd(double pixels, double maxScrollExtent) {
    if (maxScrollExtent <= 0) return;
    final triggerOffset =
        maxScrollExtent - AppSizes.bookstoreLoadMoreTriggerOffset;
    if (pixels >= triggerOffset) {
      loadMore();
    }
  }

  /// 追加下一页结果（Phase 1：循环种子数据模拟无限流）。
  Future<void> loadMore() async {
    final seed = state.domain.seedItems;
    if (state.ui.isLoadingMore || seed.isEmpty) return;

    emit(state.copyWith(ui: state.ui.copyWith(isLoadingMore: true)));
    await Future<void>.delayed(AppDurations.normal);

    final nextPage = state.ui.page + 1;
    final offset = nextPage * seed.length;
    final moreItems = <CategoryBookItem>[
      for (var i = 0; i < seed.length; i++)
        _withNewId(seed[i], 'category_more_${offset + i + 1}'),
    ];

    emit(
      state.copyWith(
        ui: state.ui.copyWith(isLoadingMore: false, page: nextPage),
        domain: state.domain.copyWith(
          items: [...state.domain.items, ...moreItems],
        ),
      ),
    );
  }

  CategoryBookItem _withNewId(CategoryBookItem source, String id) {
    return CategoryBookItem(
      book: Book(
        id: id,
        title: source.book.title,
        category: source.book.category,
        coverAsset: source.book.coverAsset,
      ),
      badgeLabel: source.badgeLabel,
      tags: source.tags,
      description: source.description,
      author: source.author,
    );
  }
}
