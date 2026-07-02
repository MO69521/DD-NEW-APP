import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../../core/domain/entities/book.dart';
import '../data/datasources/editor_pick_mock_datasource.dart';
import '../data/repositories/editor_pick_repository_impl.dart';
import '../domain/entities/editor_pick_book_item.dart';
import '../domain/repositories/editor_pick_repository.dart';
import 'editor_pick_domain_state.dart';
import 'editor_pick_state.dart';
import 'editor_pick_ui_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class EditorPickCubit extends Cubit<EditorPickState> {
  EditorPickCubit({EditorPickRepository? repository})
      : _repository = repository ??
            const EditorPickRepositoryImpl(EditorPickMockDataSource()),
        super(const EditorPickState());

  final EditorPickRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          phase: EditorPickPhase.loading,
          clearError: true,
        ),
      ),
    );

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            phase: content.items.isEmpty
                ? EditorPickPhase.empty
                : EditorPickPhase.loaded,
          ),
          domain: EditorPickDomainState(
            seedItems: content.items,
            items: content.items,
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            phase: EditorPickPhase.empty,
            errorMessage: error.toString(),
          ),
        ),
      );
    }
  }

  void onScrollNearEnd(double pixels, double maxScrollExtent) {
    if (maxScrollExtent <= 0) return;
    final triggerOffset =
        maxScrollExtent - AppSizes.bookstoreLoadMoreTriggerOffset;
    if (pixels >= triggerOffset) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    final seed = state.domain.seedItems;
    if (state.ui.isLoadingMore || seed.isEmpty) return;

    emit(state.copyWith(ui: state.ui.copyWith(isLoadingMore: true)));
    await Future<void>.delayed(AppDurations.normal);

    final nextPage = state.ui.page + 1;
    final offset = nextPage * seed.length;
    final moreItems = <EditorPickBookItem>[
      for (var i = 0; i < seed.length; i++)
        _withNewId(seed[i], 'editor_pick_more_${offset + i + 1}'),
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

  EditorPickBookItem _withNewId(EditorPickBookItem source, String id) {
    return EditorPickBookItem(
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
