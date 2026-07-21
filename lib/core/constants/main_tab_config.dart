import '../theme/app_theme_assets.dart';

/// 主 Tab 导航静态配置（App Shell 层）。
///
/// 图标路径经 [AppThemeAssets] 按编译期主题包解析；图标为完整色稿，UI 不再染色。
/// `yellow_light` 底栏选中态走 [selectedLottieAsset]（播完停末帧），未选中走 [iconAsset]
/// 静态 webp；其余主题仍用 SVG active/inactive + 缩放微动效。
class MainTabItem {
  const MainTabItem({
    required this.label,
    required this.iconAsset,
    this.selectedIconAsset,
    this.selectedLottieAsset,
  });

  final String label;
  final String iconAsset;
  final String? selectedIconAsset;

  /// 选中时播放的 Lottie；非 null 时优先于 [selectedIconAsset]。
  final String? selectedLottieAsset;
}

abstract final class MainTabConfig {
  static const int bookstoreIndex = 0;
  static const int welfareIndex = 1;
  // 暂时下线「伙伴」一级 Tab；恢复时取消注释本项与 items 对应条目，
  // 并将 [bookshelfIndex] / [profileIndex] 下标各 +1。
  // static const int partnerIndex = 2;
  static const int bookshelfIndex = 2;
  static const int profileIndex = 3;

  static const List<MainTabItem> items = [
    MainTabItem(
      label: '书城',
      iconAsset: AppThemeAssets.navBookstoreInactive,
      selectedIconAsset: AppThemeAssets.navBookstoreActive,
      selectedLottieAsset: AppThemeAssets.navBookstoreSelectedLottie,
    ),
    MainTabItem(
      label: '福利',
      iconAsset: AppThemeAssets.navWelfareInactive,
      selectedIconAsset: AppThemeAssets.navWelfareActive,
      selectedLottieAsset: AppThemeAssets.navWelfareSelectedLottie,
    ),
    // 暂时下线「伙伴」一级 Tab（三主题共用配置，恢复时取消注释）。
    // MainTabItem(
    //   label: '伙伴',
    //   iconAsset: AppThemeAssets.navPartnerInactive,
    //   selectedIconAsset: AppThemeAssets.navPartnerActive,
    //   selectedLottieAsset: AppThemeAssets.navPartnerSelectedLottie,
    // ),
    MainTabItem(
      label: '书架',
      iconAsset: AppThemeAssets.navBookshelfInactive,
      selectedIconAsset: AppThemeAssets.navBookshelfActive,
      selectedLottieAsset: AppThemeAssets.navBookshelfSelectedLottie,
    ),
    MainTabItem(
      label: '我的',
      iconAsset: AppThemeAssets.navProfileInactive,
      selectedIconAsset: AppThemeAssets.navProfileActive,
      selectedLottieAsset: AppThemeAssets.navProfileSelectedLottie,
    ),
  ];
}
