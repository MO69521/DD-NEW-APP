import '../../../../core/config/app_theme_id.dart';
import '../../domain/entities/dress_up_item.dart';
import '../../domain/entities/dress_up_page_content.dart';
import '../../domain/entities/dress_up_tab.dart';
import 'dress_up_data_source.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class DressUpMockDataSource implements DressUpDataSource {
  const DressUpMockDataSource();

  /// 头部背景素材图（与「我的」页 Hero 保持一致；按主题分包）。
  static const String _heroBackgroundAsset =
      'assets/images/profile/${AppThemeId.assetPack}/hero_background_default.png';

  @override
  Future<DressUpPageContent> fetchPageContent() async {
    return const DressUpPageContent(
      userId: '1013971429',
      nickname: '宇宙无敌美少女',
      avatarUrl: '',
      heroBackgroundAsset: _heroBackgroundAsset,
      itemsByTab: {
        DressUpTab.homeBackground: _homeBackgrounds,
        DressUpTab.avatar: _avatars,
        DressUpTab.avatarPendant: _pendants,
        DressUpTab.title: _titles,
      },
    );
  }

  static const List<DressUpItem> _homeBackgrounds = [
    DressUpItem(
      id: 'bg_default',
      name: '默认背景',
      thumbnailAsset: _heroBackgroundAsset,
      validityLabel: '恢复默认背景',
      isEquipped: true,
    ),
    DressUpItem(id: 'bg_protect', name: '保护我方太太', validityLabel: '有效期：会员期间'),
    DressUpItem(id: 'bg_sameday', name: '我被困在同一天', validityLabel: '有效期：永久'),
    DressUpItem(id: 'bg_butler', name: '垂耳执事', validityLabel: '有效期：永久'),
    DressUpItem(id: 'bg_gentleman', name: '熟男诱惑款限定', validityLabel: '有效期：永久'),
    DressUpItem(id: 'bg_steward', name: '魔皇大管家', validityLabel: '有效期：永久'),
    DressUpItem(id: 'bg_immortal', name: '长生俱乐部', validityLabel: '有效期：永久'),
  ];

  static const List<DressUpItem> _avatars = [
    DressUpItem(
      id: 'avatar_default',
      name: '默认头像',
      validityLabel: '恢复默认头像',
      isEquipped: true,
    ),
    DressUpItem(id: 'avatar_moon', name: '月下美人', validityLabel: '有效期：会员期间'),
    DressUpItem(id: 'avatar_star', name: '星河入梦', validityLabel: '有效期：永久'),
    DressUpItem(id: 'avatar_snow', name: '雪落无声', validityLabel: '有效期：永久'),
  ];

  static const List<DressUpItem> _pendants = [
    DressUpItem(
      id: 'pendant_none',
      name: '无挂件',
      validityLabel: '取消挂件',
      isEquipped: true,
    ),
    DressUpItem(id: 'pendant_crown', name: '皇冠', validityLabel: '有效期：会员期间'),
    DressUpItem(id: 'pendant_wing', name: '天使之翼', validityLabel: '有效期：永久'),
  ];

  static const List<DressUpItem> _titles = [
    DressUpItem(
      id: 'title_none',
      name: '无称号',
      validityLabel: '取消称号',
      isEquipped: true,
    ),
    DressUpItem(id: 'title_vip', name: '尊贵会员', validityLabel: '有效期：会员期间'),
    DressUpItem(id: 'title_reader', name: '资深书虫', validityLabel: '有效期：永久'),
  ];
}
