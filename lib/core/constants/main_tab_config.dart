import '../theme/app_theme_assets.dart';
import 'nav_select_motion_kind.dart';

export 'nav_select_motion_kind.dart';

/// 主 Tab 导航静态配置（App Shell 层）。
///
/// 图标路径经 [AppThemeAssets] 按编译期主题包解析；图标为完整色稿，UI 不再染色。
/// `yellow_light` 底栏选中态走 [MainTabItem.selectedLottieAsset]（播完停末帧），未选中走
/// [MainTabItem.iconAsset] 静态 webp；`yellow_dark` 四 Tab 可走 [NavSelectMotionKind]
/// 路径动效；其余主题 SVG + 缩放。
class MainTabItem {
  const MainTabItem({
    required this.label,
    required this.iconAsset,
    this.selectedIconAsset,
    this.selectedLottieAsset,
    this.selectMotion,
  });

  final String label;
  final String iconAsset;
  final String? selectedIconAsset;

  /// 选中时播放的 Lottie；非 null 时优先于 [selectedIconAsset] / [selectMotion]。
  final String? selectedLottieAsset;

  /// 选中时播放路径 trim + 填充弹出动效（当前四 Tab · `yellow_dark`）。
  final NavSelectMotionKind? selectMotion;

  bool get usesSelectMotion => selectMotion != null;
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
      selectMotion: AppThemeAssets.navBookstoreSelectMotion,
    ),
    MainTabItem(
      label: '福利',
      iconAsset: AppThemeAssets.navWelfareInactive,
      selectedIconAsset: AppThemeAssets.navWelfareActive,
      selectedLottieAsset: AppThemeAssets.navWelfareSelectedLottie,
      selectMotion: AppThemeAssets.navWelfareSelectMotion,
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
      selectMotion: AppThemeAssets.navBookshelfSelectMotion,
    ),
    MainTabItem(
      label: '我的',
      iconAsset: AppThemeAssets.navProfileInactive,
      selectedIconAsset: AppThemeAssets.navProfileActive,
      selectedLottieAsset: AppThemeAssets.navProfileSelectedLottie,
      selectMotion: AppThemeAssets.navProfileSelectMotion,
    ),
  ];
}
