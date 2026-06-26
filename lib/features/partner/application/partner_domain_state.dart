import 'package:equatable/equatable.dart';

import '../domain/entities/partner_character.dart';
import '../domain/entities/partner_page_content.dart';

/// 领域状态：页面内容与可见角色列表。
class PartnerDomainState extends Equatable {
  const PartnerDomainState({
    this.content,
    this.seedCharacters = const [],
    this.visibleCharacters = const [],
    this.messageUnreadCount = 0,
  });

  final PartnerPageContent? content;
  final List<PartnerCharacter> seedCharacters;
  final List<PartnerCharacter> visibleCharacters;
  final int messageUnreadCount;

  List<String> get categoryTags => content?.categoryTags ?? const [];

  PartnerDomainState copyWith({
    PartnerPageContent? content,
    List<PartnerCharacter>? seedCharacters,
    List<PartnerCharacter>? visibleCharacters,
    int? messageUnreadCount,
  }) {
    return PartnerDomainState(
      content: content ?? this.content,
      seedCharacters: seedCharacters ?? this.seedCharacters,
      visibleCharacters: visibleCharacters ?? this.visibleCharacters,
      messageUnreadCount: messageUnreadCount ?? this.messageUnreadCount,
    );
  }

  @override
  List<Object?> get props => [
        content,
        seedCharacters,
        visibleCharacters,
        messageUnreadCount,
      ];
}
