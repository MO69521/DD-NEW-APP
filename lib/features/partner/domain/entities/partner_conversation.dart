import 'package:equatable/equatable.dart';

/// 消息 Tab 会话列表项。
class PartnerConversation extends Equatable {
  const PartnerConversation({
    required this.id,
    required this.characterId,
    required this.characterName,
    required this.avatarAsset,
    required this.affectionLevel,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  final String id;
  final String characterId;
  final String characterName;
  final String avatarAsset;
  final int affectionLevel;
  final String lastMessagePreview;
  final DateTime lastMessageAt;
  final int unreadCount;

  @override
  List<Object?> get props => [
        id,
        characterId,
        characterName,
        avatarAsset,
        affectionLevel,
        lastMessagePreview,
        lastMessageAt,
        unreadCount,
      ];
}
