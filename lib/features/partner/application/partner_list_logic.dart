import '../../../core/theme/app_sizes.dart';
import '../domain/entities/partner_character.dart';
import '../domain/entities/partner_collection_status.dart';
import '../domain/entities/partner_conversation.dart';
import '../domain/entities/partner_interaction_scene.dart';
import '../domain/entities/partner_sort_mode.dart';
import 'partner_interaction_state.dart';

/// 伙伴列表纯逻辑（过滤 / 排序 / mock 分页生成），与 cubit 状态编排解耦，便于单测。

/// 是否已滚动到触发分页加载的阈值。
bool partnerShouldLoadMore(double pixels, double maxScrollExtent) {
  if (maxScrollExtent <= 0) return false;
  // 内容不足一屏时 maxScrollExtent 很小，triggerOffset 可能为负而误触发。
  if (maxScrollExtent < AppSizes.partnerLoadMoreTriggerOffset) return false;
  return pixels >= maxScrollExtent - AppSizes.partnerLoadMoreTriggerOffset;
}

/// 按 topTab + 分类标签 + 筛选项过滤角色，并按排序模式排序。
List<PartnerCharacter> filterPartnerCharacters({
  required List<PartnerCharacter> characters,
  required PartnerInteractionState interaction,
  required List<String> categoryTags,
  required List<String> filterOptions,
}) {
  var result = characters.where((c) => c.topTab == interaction.topTab);

  if (categoryTags.isNotEmpty && interaction.selectedCategoryIndex > 0) {
    final tag = categoryTags[interaction.selectedCategoryIndex];
    result = result.where(
      (c) => c.traitTags.contains(tag) || c.name.contains(tag),
    );
  }

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
  return List.unmodifiable(list);
}

/// 会话按最近消息时间倒序。
List<PartnerConversation> sortPartnerConversations(
  List<PartnerConversation> conversations,
) {
  final sorted = [...conversations]
    ..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
  return List.unmodifiable(sorted);
}

/// mock 分页：克隆种子角色生成下一页（Phase 2 由后端分页替换）。
List<PartnerCharacter> generateMorePartnerCharacters(
  List<PartnerCharacter> seed,
  int offset,
) {
  return List<PartnerCharacter>.generate(seed.length, (index) {
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
}

/// mock 分页：克隆种子会话生成下一页。
List<PartnerConversation> generateMorePartnerConversations(
  List<PartnerConversation> seed,
  int offset,
) {
  return List<PartnerConversation>.generate(seed.length, (index) {
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
}

/// mock 分页：克隆种子互动场景生成下一页。
List<PartnerInteractionScene> generateMorePartnerInteractionScenes(
  List<PartnerInteractionScene> seed,
  int offset,
) {
  return List<PartnerInteractionScene>.generate(seed.length, (i) {
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
}
