import '../../domain/entities/partner_character.dart';
import '../../domain/entities/partner_collection_status.dart';
import '../../domain/entities/partner_conversation.dart';
import '../../domain/entities/partner_interaction_scene.dart';
import '../../domain/entities/partner_page_content.dart';
import '../../domain/entities/partner_top_tab.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class PartnerMockDataSource {
  const PartnerMockDataSource();

  static const int _mockLatencyMs = 200;

  Future<PartnerPageContent> fetchPageContent() async {
    await Future<void>.delayed(const Duration(milliseconds: _mockLatencyMs));

    final conversations = _buildConversations();
    final messageUnreadCount = conversations.fold<int>(
      0,
      (sum, item) => sum + item.unreadCount,
    );

    return PartnerPageContent(
      categoryTags: _categoryTags,
      characters: _characters,
      conversations: conversations,
      interactionScenes: _interactionScenes,
      messageUnreadCount: messageUnreadCount,
      interactionUnreadCount: 120,
      filterOptions: _filterOptions,
    );
  }

  static List<PartnerConversation> _buildConversations() {
    final now = DateTime.now();
    const preview =
        '林子杰放下手中的相机，略微抬头，眼神中带着一丝不易察觉的疑惑……';

    return [
      PartnerConversation(
        id: 'c1',
        characterId: 'char_luzhaoheng',
        characterName: '陆昭衡',
        avatarAsset: _portrait1,
        affectionLevel: 27,
        lastMessagePreview: preview,
        lastMessageAt: DateTime(now.year, now.month, now.day, 8, 32),
        unreadCount: 1,
      ),
      PartnerConversation(
        id: 'c2',
        characterId: 'char_wenchengyu',
        characterName: '温承宇',
        avatarAsset: _portrait2,
        affectionLevel: 89,
        lastMessagePreview: preview,
        lastMessageAt: DateTime(now.year, now.month, now.day, 14, 16),
        unreadCount: 16,
      ),
      PartnerConversation(
        id: 'c3',
        characterId: 'char_samuel',
        characterName: '塞缪尔',
        avatarAsset: _portrait3,
        affectionLevel: 8,
        lastMessagePreview: preview,
        lastMessageAt: now.subtract(const Duration(days: 2)),
        unreadCount: 2,
      ),
      PartnerConversation(
        id: 'c4',
        characterId: 'char_shengxiangyang',
        characterName: '盛向阳',
        avatarAsset: _portrait1,
        affectionLevel: 45,
        lastMessagePreview: '逃？你觉得你能逃到哪里去？',
        lastMessageAt: now.subtract(const Duration(days: 3)),
        unreadCount: 0,
      ),
      PartnerConversation(
        id: 'c5',
        characterId: 'char_shiqi',
        characterName: '时致',
        avatarAsset: _portrait3,
        affectionLevel: 62,
        lastMessagePreview: '光太亮的地方，不适合你。',
        lastMessageAt: now.subtract(const Duration(days: 5)),
        unreadCount: 3,
      ),
      PartnerConversation(
        id: 'c6',
        characterId: 'char_shenqingci',
        characterName: '沈清辞',
        avatarAsset: _portrait2,
        affectionLevel: 15,
        lastMessagePreview: '别靠太近，我会失控。',
        lastMessageAt: now.subtract(const Duration(days: 7)),
        unreadCount: 0,
      ),
      PartnerConversation(
        id: 'c7',
        characterId: 'char_gubeichen',
        characterName: '顾北辰',
        avatarAsset: _portrait3,
        affectionLevel: 33,
        lastMessagePreview: '放学别走，我有话跟你说。',
        lastMessageAt: now.subtract(const Duration(days: 12)),
        unreadCount: 5,
      ),
      PartnerConversation(
        id: 'c8',
        characterId: 'char_jiangxubai',
        characterName: '江叙白',
        avatarAsset: _portrait2,
        affectionLevel: 71,
        lastMessagePreview: '伤口交给我，别自己忍着。',
        lastMessageAt: now.subtract(const Duration(days: 20)),
        unreadCount: 0,
      ),
      PartnerConversation(
        id: 'c9',
        characterId: 'char_fuchenzhou',
        characterName: '傅沉舟',
        avatarAsset: _portrait1,
        affectionLevel: 54,
        lastMessagePreview: '合同签了，就别想跑。',
        lastMessageAt: now.subtract(const Duration(days: 35)),
        unreadCount: 12,
      ),
      PartnerConversation(
        id: 'c10',
        characterId: 'char_linixingye',
        characterName: '林星野',
        avatarAsset: _portrait3,
        affectionLevel: 96,
        lastMessagePreview: '舞台下，你也只能看我一个人。',
        lastMessageAt: now.subtract(const Duration(days: 45)),
        unreadCount: 8,
      ),
      PartnerConversation(
        id: 'c11',
        characterId: 'char_wenrenheng',
        characterName: '闻人珩',
        avatarAsset: _portrait4,
        affectionLevel: 41,
        lastMessagePreview: '钥匙在我手里，你哪儿也去不了。',
        lastMessageAt: now.subtract(const Duration(days: 60)),
        unreadCount: 0,
      ),
      PartnerConversation(
        id: 'c12',
        characterId: 'char_peiji',
        characterName: '裴寂',
        avatarAsset: _portrait4,
        affectionLevel: 22,
        lastMessagePreview: '游戏规则，从现在起由我定。',
        lastMessageAt: now.subtract(const Duration(days: 90)),
        unreadCount: 1,
      ),
    ];
  }

  static const List<String> _categoryTags = [
    '全部',
    '病娇',
    '霸总',
    '疯批',
    '温柔',
    '少年感',
    '冷淡',
  ];

  static const List<String> _filterOptions = [
    '综合排序',
    '按热度',
    '按新作',
    '按互动',
    '仅看已收集',
    '仅看未收集',
  ];

  static const String _portrait1 = 'assets/images/partner/portrait_01.png';
  static const String _portrait2 = 'assets/images/partner/portrait_02.png';
  static const String _portrait3 = 'assets/images/partner/portrait_03.png';
  static const String _portrait4 = 'assets/images/partner/portrait_04.png';

  static const List<PartnerCharacter> _characters = [
    // ── 探索（Figma 1004:2167 原型 + 扩展） ──
    PartnerCharacter(
      id: 'p1',
      name: '盛向阳',
      eraTitle: '掌控时代',
      quote: '逃？你觉得你能逃到哪里去？',
      sourceTitle: '豪门模拟：少爷们都沦陷了',
      traitTags: ['总裁', '疯批'],
      followerCount: '12.8万粉丝',
      coverAsset: _portrait1,
      collectionStatus: PartnerCollectionStatus.collected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p2',
      name: '盛欢',
      eraTitle: '追梦时代',
      quote: '别怕，有我在，一步都不会让你落下。',
      sourceTitle: '豪门模拟：少爷们都沦陷了',
      traitTags: ['青梅竹马', '温柔'],
      followerCount: '9.6万粉丝',
      coverAsset: _portrait2,
      collectionStatus: PartnerCollectionStatus.uncollected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p3',
      name: '时致',
      eraTitle: '至暗时代',
      quote: '光太亮的地方，不适合你。',
      sourceTitle: '暗夜王座：权臣的私有物',
      traitTags: ['青梅竹马', '疯批'],
      followerCount: '11.2万粉丝',
      coverAsset: _portrait3,
      collectionStatus: PartnerCollectionStatus.uncollected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p4',
      name: '严天一',
      eraTitle: '狂野时代',
      quote: '规则？那是给弱者准备的。',
      sourceTitle: '极速心动：赛车手别回头',
      traitTags: ['少年感', '疯批'],
      followerCount: '8.4万粉丝',
      coverAsset: _portrait4,
      collectionStatus: PartnerCollectionStatus.collected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p5',
      name: '陆景深',
      eraTitle: '偏执时代',
      quote: '你只能看着我，听见了吗？',
      sourceTitle: '病态沉溺：少将军柔软可妻',
      traitTags: ['病娇', '霸总'],
      followerCount: '15.2万粉丝',
      coverAsset: _portrait1,
      collectionStatus: PartnerCollectionStatus.collected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p6',
      name: '沈清辞',
      eraTitle: '清冷时代',
      quote: '别靠太近，我会失控。',
      sourceTitle: '清冷仙尊他破戒了',
      traitTags: ['冷淡', '仙侠'],
      followerCount: '7.3万粉丝',
      coverAsset: _portrait2,
      collectionStatus: PartnerCollectionStatus.uncollected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p7',
      name: '顾北辰',
      eraTitle: '少年时代',
      quote: '放学别走，我有话跟你说。',
      sourceTitle: '校园心动日记',
      traitTags: ['少年感', '校园'],
      followerCount: '6.1万粉丝',
      coverAsset: _portrait3,
      collectionStatus: PartnerCollectionStatus.collected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p8',
      name: '裴寂',
      eraTitle: '疯批时代',
      quote: '游戏规则，从现在起由我定。',
      sourceTitle: '全网都在磕我们 CP',
      traitTags: ['疯批', '娱乐圈'],
      followerCount: '11.4万粉丝',
      coverAsset: _portrait4,
      collectionStatus: PartnerCollectionStatus.uncollected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p9',
      name: '江叙白',
      eraTitle: '纯白时代',
      quote: '伤口交给我，别自己忍着。',
      sourceTitle: '穿书后我成了团宠',
      traitTags: ['温柔', '穿书'],
      followerCount: '5.8万粉丝',
      coverAsset: _portrait2,
      collectionStatus: PartnerCollectionStatus.uncollected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p10',
      name: '傅沉舟',
      eraTitle: '深渊时代',
      quote: '合同签了，就别想跑。',
      sourceTitle: '偏执大佬的掌心宠',
      traitTags: ['霸总', '病娇'],
      followerCount: '10.5万粉丝',
      coverAsset: _portrait1,
      collectionStatus: PartnerCollectionStatus.collected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p11',
      name: '林星野',
      eraTitle: '星野时代',
      quote: '舞台下，你也只能看我一个人。',
      sourceTitle: '顶流秘密恋人',
      traitTags: ['少年感', '娱乐圈'],
      followerCount: '13.7万粉丝',
      coverAsset: _portrait3,
      collectionStatus: PartnerCollectionStatus.uncollected,
      topTab: PartnerTopTab.explore,
    ),
    PartnerCharacter(
      id: 'p12',
      name: '闻人珩',
      eraTitle: '囚笼时代',
      quote: '钥匙在我手里，你哪儿也去不了。',
      sourceTitle: '豪门模拟：少爷们都沦陷了',
      traitTags: ['疯批', '豪门'],
      followerCount: '9.1万粉丝',
      coverAsset: _portrait4,
      collectionStatus: PartnerCollectionStatus.collected,
      topTab: PartnerTopTab.explore,
    ),
  ];

  static const List<PartnerInteractionScene> _interactionScenes = [
    PartnerInteractionScene(
      id: 'is1',
      characterId: 'char_linchu',
      characterName: '林初',
      backgroundAsset: _portrait1,
      affectionLevel: 12,
      upgradeHint: '再表白238就升级啦',
      sceneIndex: 14,
      totalScenes: 19,
    ),
    PartnerInteractionScene(
      id: 'is2',
      characterId: 'char_huoyan',
      characterName: '霍言',
      backgroundAsset: _portrait2,
      affectionLevel: 28,
      upgradeHint: '再表白156就升级啦',
      sceneIndex: 3,
      totalScenes: 12,
    ),
    PartnerInteractionScene(
      id: 'is3',
      characterId: 'char_jiyuchuan',
      characterName: '季屿川',
      backgroundAsset: _portrait3,
      affectionLevel: 45,
      upgradeHint: '再表白89就升级啦',
      sceneIndex: 7,
      totalScenes: 15,
    ),
    PartnerInteractionScene(
      id: 'is4',
      characterId: 'char_yanchangfeng',
      characterName: '燕长风',
      backgroundAsset: _portrait4,
      affectionLevel: 8,
      upgradeHint: '再表白312就升级啦',
      sceneIndex: 1,
      totalScenes: 10,
    ),
    PartnerInteractionScene(
      id: 'is5',
      characterId: 'char_mingyue',
      characterName: '明越',
      backgroundAsset: _portrait1,
      affectionLevel: 67,
      upgradeHint: '再表白42就升级啦',
      sceneIndex: 9,
      totalScenes: 11,
    ),
    PartnerInteractionScene(
      id: 'is6',
      characterId: 'char_shengxiangyang',
      characterName: '盛向阳',
      backgroundAsset: _portrait3,
      affectionLevel: 33,
      upgradeHint: '再表白178就升级啦',
      sceneIndex: 5,
      totalScenes: 18,
    ),
  ];
}
