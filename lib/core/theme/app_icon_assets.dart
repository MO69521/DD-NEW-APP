/// 跨主题、跨 feature 的通用图标路径常量（场景归类于 `assets/icons/shared/`、
/// `assets/icons/search/` 等）。
///
/// 与 [AppThemeAssets] 分工：后者管「随 THEME 变」的色稿；本类只放不随主题切的
/// 通用 UI 图标。页面禁止裸写 `'assets/icons/…'` 散落路径。
abstract final class AppIconAssets {
  // ── shared · 列表 / 区块导航与状态角标 ──
  static const String arrowRight = 'assets/icons/shared/arrow_right.svg';
  static const String chevronDown = 'assets/icons/shared/chevron_down.svg';
  static const String hotFlame = 'assets/icons/shared/hot_flame.svg';

  // ── search · 搜索入口 / 空态 ──
  static const String search = 'assets/icons/search/search.svg';
}
