import 'package:equatable/equatable.dart';

import 'dress_up_item.dart';
import 'dress_up_tab.dart';

/// 我的装扮页聚合内容：头部用户信息 + 各 Tab 装扮项。
class DressUpPageContent extends Equatable {
  const DressUpPageContent({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
    required this.heroBackgroundAsset,
    required this.itemsByTab,
  });

  final String userId;
  final String nickname;
  final String avatarUrl;

  /// 头部背景素材图（与「我的」页一致）。
  final String heroBackgroundAsset;

  final Map<DressUpTab, List<DressUpItem>> itemsByTab;

  List<DressUpItem> itemsFor(DressUpTab tab) => itemsByTab[tab] ?? const [];

  @override
  List<Object?> get props => [
    userId,
    nickname,
    avatarUrl,
    heroBackgroundAsset,
    itemsByTab,
  ];
}
