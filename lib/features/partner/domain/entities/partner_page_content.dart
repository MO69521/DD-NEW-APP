import 'package:equatable/equatable.dart';

import 'partner_character.dart';
import 'partner_conversation.dart';
import 'partner_interaction_scene.dart';

/// 伙伴页内容聚合（探索角色 + 消息会话 + 互动场景）。
class PartnerPageContent extends Equatable {
  const PartnerPageContent({
    required this.categoryTags,
    required this.characters,
    required this.conversations,
    required this.interactionScenes,
    required this.messageUnreadCount,
    required this.interactionUnreadCount,
    required this.filterOptions,
  });

  final List<String> categoryTags;
  final List<PartnerCharacter> characters;
  final List<PartnerConversation> conversations;
  final List<PartnerInteractionScene> interactionScenes;
  final int messageUnreadCount;
  final int interactionUnreadCount;
  final List<String> filterOptions;

  @override
  List<Object?> get props => [
        categoryTags,
        characters,
        conversations,
        interactionScenes,
        messageUnreadCount,
        interactionUnreadCount,
        filterOptions,
      ];
}
