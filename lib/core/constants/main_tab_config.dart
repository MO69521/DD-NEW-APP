/// 主 Tab 导航静态配置（App Shell 层）。
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
      iconAsset: 'assets/icons/nav/bookstore_inactive.svg',
      selectedIconAsset: 'assets/icons/nav/bookstore_active.png',
    ),
    MainTabItem(
      label: '福利',
      iconAsset: 'assets/icons/nav/welfare_inactive.png',
      selectedIconAsset: 'assets/icons/nav/welfare_active.png',
    ),
    MainTabItem(
      label: '伙伴',
      iconAsset: 'assets/icons/nav/partner_inactive.png',
      selectedIconAsset: 'assets/icons/nav/partner_active.png',
    ),
    MainTabItem(
      label: '书架',
      iconAsset: 'assets/icons/nav/bookshelf_inactive.png',
      selectedIconAsset: 'assets/icons/nav/bookshelf_active.png',
    ),
    MainTabItem(
      label: '我的',
      iconAsset: 'assets/icons/nav/profile_inactive.png',
      selectedIconAsset: 'assets/icons/nav/profile_active.png',
    ),
  ];
}
