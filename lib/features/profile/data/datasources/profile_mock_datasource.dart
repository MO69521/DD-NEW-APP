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
        avatarUrl: '',
        partnerAvatarUrls: _mockPartnerAvatarUrls,
      ),
      currencyBalances: CurrencyMockData.welfareBalances,
      vipMonthlyEnergy: _vipMonthlyEnergy,
      vipPriceYuan: _vipPriceYuan,
      rechargePackages: _rechargePackages,
      menuItems: _menuItems,
    );
  }

  static const List<String> _mockPartnerAvatarUrls = [
    '',
    '',
    '',
    '',
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
      iconAsset: 'assets/icons/profile/reading_history.svg',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.helpFeedback,
      label: '帮助与反馈',
      iconAsset: 'assets/icons/profile/help_feedback.svg',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.qqGroup,
      label: 'QQ群:406584',
      iconAsset: 'assets/icons/profile/qq_group.svg',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.settings,
      label: '设置',
      iconAsset: 'assets/icons/profile/settings.svg',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.cardPack,
      label: '我的卡包',
      iconAsset: 'assets/icons/profile/card_pack.svg',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.dressUp,
      label: '装扮中心',
      iconAsset: 'assets/icons/profile/dress_up.svg',
    ),
    ProfileMenuItem(
      action: ProfileMenuAction.cardAlbum,
      label: '我的卡册',
      iconAsset: 'assets/icons/profile/card_album.svg',
    ),
  ];
}
