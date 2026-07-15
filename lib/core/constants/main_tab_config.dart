import '../theme/app_theme_assets.dart';

/// 主 Tab 导航静态配置（App Shell 层）。
///
/// 图标路径经 [AppThemeAssets] 按编译期主题包解析；图标为完整色稿，UI 不再染色。
class MainTabItem {
  const MainTabItem({
    required this.label,
    required this.iconAsset,
    this.selectedIconAsset,
  });

  final String label;
  final String iconAsset;
  final String? selectedIconAsset;
}

abstract final class MainTabConfig {
  static const int bookstoreIndex = 0;
  static const int welfareIndex = 1;
  static const int partnerIndex = 2;
  static const int bookshelfIndex = 3;
  static const int profileIndex = 4;

  static const List<MainTabItem> items = [
    MainTabItem(
      label: '书城',
      iconAsset: AppThemeAssets.navBookstoreInactive,
      selectedIconAsset: AppThemeAssets.navBookstoreActive,
    ),
    MainTabItem(
      label: '福利',
      iconAsset: AppThemeAssets.navWelfareInactive,
      selectedIconAsset: AppThemeAssets.navWelfareActive,
    ),
    MainTabItem(
      label: '伙伴',
      iconAsset: AppThemeAssets.navPartnerInactive,
      selectedIconAsset: AppThemeAssets.navPartnerActive,
    ),
    MainTabItem(
      label: '书架',
      iconAsset: AppThemeAssets.navBookshelfInactive,
      selectedIconAsset: AppThemeAssets.navBookshelfActive,
    ),
    MainTabItem(
      label: '我的',
      iconAsset: AppThemeAssets.navProfileInactive,
      selectedIconAsset: AppThemeAssets.navProfileActive,
    ),
  ];
}
