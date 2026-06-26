import 'package:equatable/equatable.dart';

import 'partner_collection_status.dart';
import 'partner_top_tab.dart';

/// 探索页角色卡片实体。
class PartnerCharacter extends Equatable {
  const PartnerCharacter({
    required this.id,
    required this.name,
    required this.eraTitle,
    required this.quote,
    required this.sourceTitle,
    required this.traitTags,
    required this.followerCount,
    required this.coverAsset,
    required this.collectionStatus,
    required this.topTab,
  });

  final String id;
  final String name;
  final String eraTitle;
  final String quote;
  final String sourceTitle;
  final List<String> traitTags;
  final String followerCount;
  final String coverAsset;
  final PartnerCollectionStatus collectionStatus;
  final PartnerTopTab topTab;

  @override
  List<Object?> get props => [
        id,
        name,
        eraTitle,
        quote,
        sourceTitle,
        traitTags,
        followerCount,
        coverAsset,
        collectionStatus,
        topTab,
      ];
}
