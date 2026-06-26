import '../../../../core/constants/currency_mock_data.dart';
import '../../../../core/domain/entities/commerce_entities.dart';
import '../../domain/entities/profile_menu_item.dart';
import '../../domain/entities/profile_page_content.dart';
import '../../domain/entities/user_profile.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class ProfileMockDataSource {
  const ProfileMockDataSource();

  Future<ProfilePageContent> fetchPageContent() async {
    return ProfilePageContent(
      user: UserProfile(
        userId: '1013971429',
        nickname: '宇宙无敌美少女',
        avatarUrl: _mockAvatarUrl,
        partnerAvatarUrls: _mockPartnerAvatarUrls,
      ),
      currencyBalances: CurrencyMockData.welfareBalances,
      vipMonthlyEnergy: _vipMonthlyEnergy,
      vipPriceYuan: _vipPriceYuan,
      rechargePackages: _rechargePackages,
      menuItems: _menuItems,
    );
  }

  static const String _mockAvatarUrl =
      'https://www.figma.com/api/mcp/asset/c27ff5ed-ffc6-410c-aa1d-d24cd1f916d8';

  static const List<String> _mockPartnerAvatarUrls = [
    'https://www.figma.com/api/mcp/asset/f682d089-6a2c-4182-954d-a72de60d5644',
    'https://www.figma.com/api/mcp/asset/2ed48e6d-0f6d-48c8-a091-2698e01f94ce',
    'https://www.figma.com/api/mcp/asset/4be6be72-6cff-4993-89bb-b2c654f68d6a',
    'https://www.figma.com/api/mcp/asset/23a56a99-4ca1-4c7d-a9c1-b19daad27efe',
  ];

  static const int _vipMonthlyEnergy = 13710;
  static const double _vipPriceYuan = 9.9;

  static const List<RechargePackage> _rechargePackages = [
    RechargePackage(
      id: 'rp1',
      energyAmount: 250,
      originalAmount: 200,
      priceYuan: 2,
      illustrationAsset: 'assets/images/welfare/recharge_tier_1.png',
    ),
    RechargePackage(
      id: 'rp2',
      energyAmount: 700,
      originalAmount: 500,
      priceYuan: 15,
      badgeLabel: '热销',
      illustrationAsset: 'assets/images/welfare/recharge_tier_2.png',
    ),
    RechargePackage(
      id: 'rp3',
      energyAmount: 4000,
      originalAmount: 2000,
      priceYuan: 20,
      illustrationAsset: 'assets/images/welfare/recharge_tier_3.png',
    ),
    RechargePackage(
      id: 'rp4',
      energyAmount: 10000,
      originalAmount: 5000,
      priceYuan: 50,
      illustrationAsset: 'assets/images/welfare/recharge_tier_4.png',
    ),
    RechargePackage(
      id: 'rp5',
      energyAmount: 25000,
      originalAmount: 15000,
      priceYuan: 100,
      badgeLabel: '热销',
      illustrationAsset: 'assets/images/welfare/recharge_tier_5.png',
    ),
    RechargePackage(
      id: 'rp6',
      energyAmount: 82800,
      originalAmount: 32800,
      priceYuan: 328,
      illustrationAsset: 'assets/images/welfare/recharge_tier_6.png',
    ),
  ];

  static const List<ProfileMenuItem> _menuItems = [
    ProfileMenuItem(
      action: ProfileMenuAction.readingHistory,
      label: '阅读历史',
      iconAsset: 'assets/icons/profile/reading_history.png',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.helpFeedback,
      label: '帮助与反馈',
      iconAsset: 'assets/icons/profile/help_feedback.png',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.qqGroup,
      label: 'QQ群:406584',
      iconAsset: 'assets/icons/profile/qq_group.png',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.settings,
      label: '设置',
      iconAsset: 'assets/icons/profile/settings.png',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.cardPack,
      label: '我的卡包',
      iconAsset: 'assets/icons/profile/card_pack.png',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.dressUp,
      label: '装扮中心',
      iconAsset: 'assets/icons/profile/dress_up.png',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.cardAlbum,
      label: '我的卡册',
      iconAsset: 'assets/icons/profile/card_album.png',
    ),
  ];
}
