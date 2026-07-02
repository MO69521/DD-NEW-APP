import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_sizes.dart';
import '../data/datasources/partner_mock_datasource.dart';
import '../data/repositories/partner_repository_impl.dart';
import '../domain/entities/partner_character.dart';
import '../domain/entities/partner_collection_status.dart';
import '../domain/entities/partner_conversation.dart';
import '../domain/entities/partner_interaction_scene.dart';
import '../domain/entities/partner_sort_mode.dart';
import '../domain/entities/partner_top_tab.dart';
import '../domain/repositories/partner_repository.dart';
import 'partner_domain_state.dart';
import 'partner_interaction_state.dart';
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
      final interaction = const PartnerInteractionState();
      final visibleCharacters = _filterCharacters(
        characters: content.characters,
        interaction: interaction,
      );
      final visibleConversations = _sortConversations(content.conversations);

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
            visibleConversations: _sortConversations(baseConversations),
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
          visibleCharacters: _filterCharacters(
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
    final moreScenes = List<PartnerInteractionScene>.generate(seed.length, (i) {
      final source = seed[i];
      return PartnerInteractionScene(
        id: 'partner_scene_more_${offset + i + 1}',
        characterId: source.characterId,
        characterName: source.characterName,
        backgroundAsset: source.backgroundAsset,
        affectionLevel: source.affectionLevel,
        upgradeHint: source.upgradeHint,
        sceneIndex: source.sceneIndex,
        totalScenes: source.totalScenes,
      );
    });

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
    if (maxScrollExtent <= 0) return;

    // 内容高度不足一屏时 maxScrollExtent 很小，会导致 triggerOffset 为负并误触发 loadMore。
    if (maxScrollExtent < AppSizes.partnerLoadMoreTriggerOffset) return;

    final triggerOffset =
        maxScrollExtent - AppSizes.partnerLoadMoreTriggerOffset;
    if (pixels >= triggerOffset) {
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
    final moreCharacters = List<PartnerCharacter>.generate(seed.length, (index) {
      final source = seed[index];
      return PartnerCharacter(
        id: 'partner_more_${offset + index + 1}',
        name: source.name,
        eraTitle: source.eraTitle,
        quote: source.quote,
        sourceTitle: source.sourceTitle,
        traitTags: source.traitTags,
        followerCount: source.followerCount,
        coverAsset: source.coverAsset,
        collectionStatus: source.collectionStatus,
        topTab: source.topTab,
      );
    });

    final merged = [...state.domain.visibleCharacters, ...moreCharacters];
    final filtered = _filterCharacters(
      characters: merged,
      interaction: state.interaction,
      seedOnly: false,
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
    final moreConversations =
        List<PartnerConversation>.generate(seed.length, (index) {
      final source = seed[index];
      return PartnerConversation(
        id: 'partner_conv_more_${offset + index + 1}',
        characterId: source.characterId,
        characterName: source.characterName,
        avatarAsset: source.avatarAsset,
        affectionLevel: source.affectionLevel,
        lastMessagePreview: source.lastMessagePreview,
        lastMessageAt: source.lastMessageAt,
        unreadCount: source.unreadCount,
      );
    });

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
          visibleConversations: _sortConversations(merged),
        ),
      ),
    );
  }

  void _emitFiltered(PartnerInteractionState interaction) {
    final filteredCharacters = _filterCharacters(
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

  List<PartnerCharacter> _filterCharacters({
    required List<PartnerCharacter> characters,
    required PartnerInteractionState interaction,
    bool seedOnly = true,
  }) {
    var result = characters.where((c) => c.topTab == interaction.topTab);

    final tags = state.domain.categoryTags;
    if (tags.isNotEmpty && interaction.selectedCategoryIndex > 0) {
      final tag = tags[interaction.selectedCategoryIndex];
      result = result.where(
        (c) => c.traitTags.contains(tag) || c.name.contains(tag),
      );
    }

    final filterOptions = state.domain.content?.filterOptions ?? const [];
    if (filterOptions.isNotEmpty && interaction.selectedFilterIndex > 0) {
      final option = filterOptions[interaction.selectedFilterIndex];
      result = switch (option) {
        '仅看已收集' => result.where(
            (c) => c.collectionStatus == PartnerCollectionStatus.collected,
          ),
        '仅看未收集' => result.where(
            (c) => c.collectionStatus == PartnerCollectionStatus.uncollected,
          ),
        '按新作' => result,
        _ => result,
      };
    }

    final list = result.toList();
    if (interaction.sortMode == PartnerSortMode.newest) {
      list.sort((a, b) => b.id.compareTo(a.id));
    }

    if (seedOnly) {
      return List.unmodifiable(list);
    }
    return List.unmodifiable(list);
  }

  List<PartnerConversation> _sortConversations(
    List<PartnerConversation> conversations,
  ) {
    final sorted = [...conversations]
      ..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    return List.unmodifiable(sorted);
  }
}
