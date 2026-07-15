import '../config/app_theme_id.dart';

/// 随主题（THEME 编译包）变化的**非颜色资源**集中解析处（Tier 2 · 资源侧）。
///
/// 与颜色层平行：颜色 token 走 `AppColors` / `AppBrandColors`，
/// 而「随主题变化的图片 / 图标资源」在此按 [AppThemeId.assetPack] 选取；组件只
/// 引用这里的语义名，不写死资源路径、不判断 themeId。
///
/// 资源目录约定（主题分包）：
/// ```text
/// assets/icons/<feature>/{dark|pink_light|yellow_light}/…  # 随主题
/// assets/icons/<feature>/shared/…                          # 跨主题共用
/// assets/images/<feature>/{dark|pink_light|yellow_light}/… # 随主题位图
/// ```
/// 未知 THEME 回退 `dark`；缺主题切图时可用 dark 拷贝占位，设计交付后只替换
/// 对应主题目录。主题色稿加载时**不再** `ColorFilter` 染色。
///
/// 新增主题包时：扩展 [AppThemeId] 合法集，为该包补资源目录，并登记
/// `pubspec.yaml` 与 `docs/09_Assets.md`。返回 `null` 表示该主题不配置该资源
/// （调用方回退默认表现，目前仅 [bottomNavTexture] 允许 null）。
abstract final class AppThemeAssets {
  static const String _pack = AppThemeId.assetPack;

  // ══════════════════════════════════════════════════════════════
  // 底部导航栏
  // ══════════════════════════════════════════════════════════════

  /// 底部导航栏背景纹理（每主题一张，铺满底栏、在半透明 scrim 下隐约透出）。
  /// 为 `null` 时底栏回退纯色填充（`AppColors.bottomNavScrim`）。
  static const String? bottomNavTexture =
      'assets/images/bottom_nav/$_pack/nav_texture.png';

  static const String navBookstoreInactive =
      'assets/icons/nav/$_pack/bookstore_inactive.svg';
  static const String navBookstoreActive =
      'assets/icons/nav/$_pack/bookstore_active.svg';
  static const String navWelfareInactive =
      'assets/icons/nav/$_pack/welfare_inactive.svg';
  static const String navWelfareActive =
      'assets/icons/nav/$_pack/welfare_active.svg';
  static const String navPartnerInactive =
      'assets/icons/nav/$_pack/partner_inactive.svg';
  static const String navPartnerActive =
      'assets/icons/nav/$_pack/partner_active.svg';
  static const String navBookshelfInactive =
      'assets/icons/nav/$_pack/bookshelf_inactive.svg';
  static const String navBookshelfActive =
      'assets/icons/nav/$_pack/bookshelf_active.svg';
  static const String navProfileInactive =
      'assets/icons/nav/$_pack/profile_inactive.svg';
  static const String navProfileActive =
      'assets/icons/nav/$_pack/profile_active.svg';

  // ══════════════════════════════════════════════════════════════
  // 登录页 / 我的页 · 头图
  // ══════════════════════════════════════════════════════════════

  /// 登录页顶部头图。
  static const String authLoginTopBg =
      'assets/images/auth/$_pack/login_top_bg.png';

  /// 「我的」页默认 Hero 头图（装扮未换背景时的公用默认图）。
  static const String profileHeroBackgroundDefault =
      'assets/images/profile/$_pack/hero_background_default.png';

  // ══════════════════════════════════════════════════════════════
  // 书籍详情 / 搜索结果 · 加入书架 / 送心（随主题）
  // ══════════════════════════════════════════════════════════════

  static const String bookDetailAddToShelf =
      'assets/icons/book_detail/$_pack/add_to_shelf.svg';
  static const String bookDetailInShelf =
      'assets/icons/book_detail/$_pack/in_shelf.svg';
  static const String bookDetailSendHeart =
      'assets/icons/book_detail/$_pack/send_heart.svg';
  static const String bookDetailSendHeartSent =
      'assets/icons/book_detail/$_pack/send_heart_sent.svg';

  // ══════════════════════════════════════════════════════════════
  // 书籍详情 · 跨主题共用（shared）
  // ══════════════════════════════════════════════════════════════

  static const String bookDetailPromoRewardTag =
      'assets/icons/book_detail/shared/promo_reward_tag.svg';
  static const String bookDetailRefresh =
      'assets/icons/book_detail/shared/refresh.svg';
}
