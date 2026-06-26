import 'package:equatable/equatable.dart';

import 'partner_character.dart';

/// 探索页内容聚合。
class PartnerPageContent extends Equatable {
  const PartnerPageContent({
    required this.categoryTags,
    required this.characters,
    required this.messageUnreadCount,
    required this.filterOptions,
  });

  final List<String> categoryTags;
  final List<PartnerCharacter> characters;
  final int messageUnreadCount;
  final List<String> filterOptions;

  @override
  List<Object?> get props => [
        categoryTags,
        characters,
        messageUnreadCount,
        filterOptions,
      ];
}
