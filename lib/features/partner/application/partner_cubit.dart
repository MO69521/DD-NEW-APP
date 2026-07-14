import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_durations.dart';
import '../data/datasources/partner_mock_datasource.dart';
import '../data/repositories/partner_repository_impl.dart';
import '../domain/entities/partner_character.dart';
import '../domain/entities/partner_sort_mode.dart';
import '../domain/entities/partner_top_tab.dart';
import '../domain/repositories/partner_repository.dart';
import 'partner_domain_state.dart';
import 'partner_interaction_state.dart';
import 'partner_list_logic.dart';
import 'partner_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class PartnerCubit extends Cubit<PartnerState> {
  PartnerCubit({PartnerRepository? repository})
      : _repository = repository ??
            const PartnerRepositoryImpl(PartnerMockDataSource()),
        super(const PartnerState());

  final PartnerRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)));

    try {
      final content = await _repository.fetchPageContent();
      const interaction = PartnerInteractionState();
      final visibleCharacters = _applyFilter(
        characters: content.characters,
        interaction: interaction,
      );
      final visibleConversations = sortPartnerConversations(
        content.conversations,
      );

      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: PartnerDomainState(
            content: content,
            seedCharacters: List.unmodifiable(content.characters),
            visibleCharacters: visibleCharacters,
            seedConversations: List.unmodifiable(content.conversations),
            visibleConversations: visibleConversations,
            seedInteractionScenes:
                List.unmodifiable(content.interactionScenes),
            visibleInteractionScenes:
                List.unmodifiable(content.interactionScenes),
            messageUnreadCount: content.messageUnreadCount,
            interactionUnreadCount: content.interactionUnreadCount,
          ),
          interaction: interaction,
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

  void switchTopTab(PartnerTopTab tab) {
    if (tab == state.interaction.topTab) return;
    final interaction = state.interaction.copyWith(topTab: tab);

    if (tab == PartnerTopTab.message) {
      final baseConversations =
          state.domain.content?.conversations ?? const [];
      emit(
        state.copyWith(
          interaction: interaction.copyWith(interactionSceneIndex: 0),
          ui: state.ui.copyWith(page: 0),
          domain: state.domain.copyWith(
          seedConversations: List.unmodifiable(baseConversations),
              visibleConversations: sortPartnerConversations(baseConversations),
          ),
        ),
      );
      return;
    }

    if (tab == PartnerTopTab.interaction) {
      final baseScenes = state.domain.content?.interactionScenes ?? const [];
      emit(
        state.copyWith(
          interaction: interaction.copyWith(interactionSceneIndex: 0),
          ui: state.ui.copyWith(page: 0),
          domain: state.domain.copyWith(
            seedInteractionScenes: List.unmodifiable(baseScenes),
            visibleInteractionScenes: List.unmodifiable(baseScenes),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        interaction: interaction.copyWith(interactionSceneIndex: 0),
        ui: state.ui.copyWith(page: 0),
        domain: state.domain.copyWith(
          visibleCharacters: _applyFilter(
            characters: state.domain.seedCharacters,
            interaction: interaction,
          ),
        ),
      ),
    );
  }

  void selectCategory(int index) {
    if (index == state.interaction.selectedCategoryIndex) return;
    final interaction =
        state.interaction.copyWith(selectedCategoryIndex: index);
    _emitFiltered(interaction);
  }

  void switchSortMode(PartnerSortMode mode) {
    if (mode == state.interaction.sortMode) return;
    final interaction = state.interaction.copyWith(sortMode: mode);
    _emitFiltered(interaction);
  }

  void openFilterSheet() {
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(isFilterSheetOpen: true),
      ),
    );
  }

  void closeFilterSheet() {
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(isFilterSheetOpen: false),
      ),
    );
  }

  void selectFilterOption(int index) {
    final interaction = state.interaction.copyWith(
      selectedFilterIndex: index,
      isFilterSheetOpen: false,
    );
    _emitFiltered(interaction);
  }

  void onInteractionPageChanged(int index) {
    if (index == state.interaction.interactionSceneIndex) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(interactionSceneIndex: index),
      ),
    );

    final scenes = state.domain.visibleInteractionScenes;
    if (scenes.isEmpty) return;
    if (index >= scenes.length - 2) {
      loadMoreInteractionScenes();
    }
  }

  Future<void> loadMoreInteractionScenes() async {
    if (state.ui.isLoadingMore) return;
    final seed = state.domain.seedInteractionScenes;
    if (seed.isEmpty) return;

    emit(state.copyWith(ui: state.ui.copyWith(isLoadingMore: true)));
    await Future<void>.delayed(AppDurations.normal);

    final nextPage = state.ui.page + 1;
    final offset = nextPage * seed.length;
    final moreScenes = generateMorePartnerInteractionScenes(seed, offset);

    emit(
      state.copyWith(
        ui: state.ui.copyWith(isLoadingMore: false, page: nextPage),
        domain: state.domain.copyWith(
          seedInteractionScenes: [
            ...state.domain.seedInteractionScenes,
            ...moreScenes,
          ],
          visibleInteractionScenes: [
            ...state.domain.visibleInteractionScenes,
            ...moreScenes,
          ],
        ),
      ),
    );
  }

  void onScrollNearEnd(double pixels, double maxScrollExtent) {
    if (partnerShouldLoadMore(pixels, maxScrollExtent)) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    if (state.ui.isLoadingMore) return;

    if (state.interaction.topTab == PartnerTopTab.message) {
      await _loadMoreConversations();
      return;
    }

    await _loadMoreCharacters();
  }

  Future<void> _loadMoreCharacters() async {
    final seed = state.domain.seedCharacters;
    if (seed.isEmpty) return;

    emit(state.copyWith(ui: state.ui.copyWith(isLoadingMore: true)));
    await Future<void>.delayed(AppDurations.normal);

    final nextPage = state.ui.page + 1;
    final offset = nextPage * seed.length;
    final moreCharacters = generateMorePartnerCharacters(seed, offset);

    final merged = [...state.domain.visibleCharacters, ...moreCharacters];
    final filtered = _applyFilter(
      characters: merged,
      interaction: state.interaction,
    );

    emit(
      state.copyWith(
        ui: state.ui.copyWith(isLoadingMore: false, page: nextPage),
        domain: state.domain.copyWith(
          seedCharacters: [...state.domain.seedCharacters, ...moreCharacters],
          visibleCharacters: filtered,
        ),
      ),
    );
  }

  Future<void> _loadMoreConversations() async {
    final seed = state.domain.seedConversations;
    if (seed.isEmpty) return;

    emit(state.copyWith(ui: state.ui.copyWith(isLoadingMore: true)));
    await Future<void>.delayed(AppDurations.normal);

    final nextPage = state.ui.page + 1;
    final offset = nextPage * seed.length;
    final moreConversations = generateMorePartnerConversations(seed, offset);

    final merged = [
      ...state.domain.visibleConversations,
      ...moreConversations,
    ];

    emit(
      state.copyWith(
        ui: state.ui.copyWith(isLoadingMore: false, page: nextPage),
        domain: state.domain.copyWith(
          seedConversations: [
            ...state.domain.seedConversations,
            ...moreConversations,
          ],
          visibleConversations: sortPartnerConversations(merged),
        ),
      ),
    );
  }

  void _emitFiltered(PartnerInteractionState interaction) {
    final filteredCharacters = _applyFilter(
      characters: state.domain.seedCharacters,
      interaction: interaction,
    );
    emit(
      state.copyWith(
        interaction: interaction,
        domain: state.domain.copyWith(visibleCharacters: filteredCharacters),
      ),
    );
  }

  /// 用当前 domain 的分类标签 / 筛选项过滤角色（委托纯函数）。
  List<PartnerCharacter> _applyFilter({
    required List<PartnerCharacter> characters,
    required PartnerInteractionState interaction,
  }) {
    return filterPartnerCharacters(
      characters: characters,
      interaction: interaction,
      categoryTags: state.domain.categoryTags,
      filterOptions: state.domain.content?.filterOptions ?? const [],
    );
  }
}
