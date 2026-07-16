import 'package:equatable/equatable.dart';

import '../domain/entities/partner_character.dart';
import '../domain/entities/partner_conversation.dart';
import '../domain/entities/partner_interaction_scene.dart';
import '../domain/entities/partner_page_content.dart';

/// 领域状态：页面内容与可见列表。
class PartnerDomainState extends Equatable {
  const PartnerDomainState({
    this.content,
    this.seedCharacters = const [],
    this.visibleCharacters = const [],
    this.seedConversations = const [],
    this.visibleConversations = const [],
    this.seedInteractionScenes = const [],
    this.visibleInteractionScenes = const [],
    this.messageUnreadCount = 0,
    this.interactionUnreadCount = 0,
  });

  final PartnerPageContent? content;
  final List<PartnerCharacter> seedCharacters;
  final List<PartnerCharacter> visibleCharacters;
  final List<PartnerConversation> seedConversations;
  final List<PartnerConversation> visibleConversations;
  final List<PartnerInteractionScene> seedInteractionScenes;
  final List<PartnerInteractionScene> visibleInteractionScenes;
  final int messageUnreadCount;
  final int interactionUnreadCount;

  List<String> get categoryTags => content?.categoryTags ?? const [];

  PartnerDomainState copyWith({
    PartnerPageContent? content,
    List<PartnerCharacter>? seedCharacters,
    List<PartnerCharacter>? visibleCharacters,
    List<PartnerConversation>? seedConversations,
    List<PartnerConversation>? visibleConversations,
    List<PartnerInteractionScene>? seedInteractionScenes,
    List<PartnerInteractionScene>? visibleInteractionScenes,
    int? messageUnreadCount,
    int? interactionUnreadCount,
  }) {
    return PartnerDomainState(
      content: content ?? this.content,
      seedCharacters: seedCharacters ?? this.seedCharacters,
      visibleCharacters: visibleCharacters ?? this.visibleCharacters,
      seedConversations: seedConversations ?? this.seedConversations,
      visibleConversations: visibleConversations ?? this.visibleConversations,
      seedInteractionScenes:
          seedInteractionScenes ?? this.seedInteractionScenes,
      visibleInteractionScenes:
          visibleInteractionScenes ?? this.visibleInteractionScenes,
      messageUnreadCount: messageUnreadCount ?? this.messageUnreadCount,
      interactionUnreadCount:
          interactionUnreadCount ?? this.interactionUnreadCount,
    );
  }

  @override
  List<Object?> get props => [
    content,
    seedCharacters,
    visibleCharacters,
    seedConversations,
    visibleConversations,
    seedInteractionScenes,
    visibleInteractionScenes,
    messageUnreadCount,
    interactionUnreadCount,
  ];
}
