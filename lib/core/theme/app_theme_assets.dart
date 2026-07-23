import '../config/app_theme_id.dart';
import '../constants/nav_select_motion_kind.dart';

/// 随主题（THEME 编译包）变化的**非颜色资源**集中解析处（Tier 2 · 资源侧）。
///
/// 与颜色层平行：颜色 token 走 `AppColors` / `AppBrandColors`，
/// 而「随主题变化的图片 / 图标资源」在此按 [AppThemeId.assetPack] 选取；组件只
/// 引用这里的语义名，不写死资源路径、不判断 themeId。
///
/// 资源目录约定（主题分包）：
/// ```text
/// assets/icons/<feature>/{yellow_dark|pink_light|yellow_light}/…  # 随主题
/// assets/icons/<feature>/shared/…                          # 跨主题共用
/// assets/images/<feature>/{yellow_dark|pink_light|yellow_light}/… # 随主题位图
/// ```
/// 未知 THEME 回退 `yellow_dark`；缺主题切图时可用 yellow_dark 拷贝占位，设计交付后只替换
/// 对应主题目录。主题色稿加载时**不再** `ColorFilter` 染色。
///
/// 新增主题包时：扩展 [AppThemeId] 合法集，为该包补资源目录，并登记
/// `pubspec.yaml` 与 `docs/09_Assets.md`。返回 `null` 表示该主题不配置该资源
/// （调用方回退默认表现，目前 [tabTopTexture] 允许 null；[bottomNavTexture] 每主题必有路径）。
abstract final class AppThemeAssets {
  static const String _pack = AppThemeId.assetPack;

  // ══════════════════════════════════════════════════════════════
  // 底部导航栏
  // ══════════════════════════════════════════════════════════════

  /// 底部导航栏背景纹理（每主题一张，铺满底栏实色 [AppColors.bottomNavScrim] 之下）。
  static const String bottomNavTexture =
      'assets/images/bottom_nav/$_pack/nav_texture.png';

  // ══════════════════════════════════════════════════════════════
  // 福利页 · 顶部纹理
  // ══════════════════════════════════════════════════════════════

  /// 福利页顶部装饰纹理（全宽装饰层）。
  /// 切图未到位时为 `null`，[AppTabTopTexture] 只保留透明槽位、不绘制贴图。
  /// 切图到位后改为：`'assets/images/tab_top/$_pack/top_texture.png'`。
  static const String? tabTopTexture = null;

  static const String navBookstoreInactive = _pack == AppThemeId.yellowLight
      ? 'assets/images/bottom_nav/yellow_light/bookcity_nor.webp'
      : 'assets/icons/nav/$_pack/bookstore_inactive.svg';
  static const String? navBookstoreActive = _pack == AppThemeId.yellowLight
      ? null
      : 'assets/icons/nav/$_pack/bookstore_active.svg';
  static const String? navBookstoreSelectedLottie = _pack == AppThemeId.yellowLight
      ? 'assets/lottie/bottom_nav/yellow_light/book_city/book_city.json'
      : null;

  /// 底栏选中路径动效种类；当前仅 `yellow_dark` 四 Tab；其它主题仍走 Lottie / SVG 缩放。
  static const NavSelectMotionKind? navBookstoreSelectMotion =
      _pack == AppThemeId.yellowDark ? NavSelectMotionKind.bookstore : null;

  static const String navWelfareInactive = _pack == AppThemeId.yellowLight
      ? 'assets/images/bottom_nav/yellow_light/welfare_nor.webp'
      : 'assets/icons/nav/$_pack/welfare_inactive.svg';
  static const String? navWelfareActive = _pack == AppThemeId.yellowLight
      ? null
      : 'assets/icons/nav/$_pack/welfare_active.svg';
  static const String? navWelfareSelectedLottie = _pack == AppThemeId.yellowLight
      ? 'assets/lottie/bottom_nav/yellow_light/welfare/data.json'
      : null;

  static const NavSelectMotionKind? navWelfareSelectMotion =
      _pack == AppThemeId.yellowDark ? NavSelectMotionKind.welfare : null;

  /// 福利「签到」态静态 / Lottie（素材已入库；当前底栏默认仍用福利礼盒，待产品接线）。
  static const String? navWelfareSignInactive = _pack == AppThemeId.yellowLight
      ? 'assets/images/bottom_nav/yellow_light/sign_nor.webp'
      : null;
  static const String? navWelfareSignSelectedLottie =
      _pack == AppThemeId.yellowLight
      ? 'assets/lottie/bottom_nav/yellow_light/sign/data.json'
      : null;

  static const String navPartnerInactive = _pack == AppThemeId.yellowLight
      ? 'assets/images/bottom_nav/yellow_light/partner_nor.webp'
      : 'assets/icons/nav/$_pack/partner_inactive.svg';
  static const String? navPartnerActive = _pack == AppThemeId.yellowLight
      ? null
      : 'assets/icons/nav/$_pack/partner_active.svg';
  static const String? navPartnerSelectedLottie = _pack == AppThemeId.yellowLight
      ? 'assets/lottie/bottom_nav/yellow_light/partner/data.json'
      : null;

  static const String navBookshelfInactive = _pack == AppThemeId.yellowLight
      ? 'assets/images/bottom_nav/yellow_light/bookcase_nor.webp'
      : 'assets/icons/nav/$_pack/bookshelf_inactive.svg';
  static const String? navBookshelfActive = _pack == AppThemeId.yellowLight
      ? null
      : 'assets/icons/nav/$_pack/bookshelf_active.svg';
  static const String? navBookshelfSelectedLottie = _pack == AppThemeId.yellowLight
      ? 'assets/lottie/bottom_nav/yellow_light/bookcase/bookcase.json'
      : null;

  static const NavSelectMotionKind? navBookshelfSelectMotion =
      _pack == AppThemeId.yellowDark ? NavSelectMotionKind.bookshelf : null;

  static const String navProfileInactive = _pack == AppThemeId.yellowLight
      ? 'assets/images/bottom_nav/yellow_light/mine_nor.webp'
      : 'assets/icons/nav/$_pack/profile_inactive.svg';
  static const String? navProfileActive = _pack == AppThemeId.yellowLight
      ? null
      : 'assets/icons/nav/$_pack/profile_active.svg';
  static const String? navProfileSelectedLottie = _pack == AppThemeId.yellowLight
      ? 'assets/lottie/bottom_nav/yellow_light/mine/mine.json'
      : null;

  static const NavSelectMotionKind? navProfileSelectMotion =
      _pack == AppThemeId.yellowDark ? NavSelectMotionKind.profile : null;

  /// 限时免费区块顶部彩头：深色用紫黑 FREE 水印；浅色仍用 shared 浅紫→白渐隐。
  static const String limitedFreeHeaderBg = _pack == AppThemeId.yellowDark
      ? 'assets/images/bookstore/yellow_dark/limited_free_header_bg.png'
      : 'assets/images/bookstore/shared/limited_free_header_bg.png';

  // ══════════════════════════════════════════════════════════════
  // 登录页 / 我的页 · 头图
  // ══════════════════════════════════════════════════════════════

  /// 「我的」页默认 Hero 头图（装扮未换背景时的公用默认图）。
  static const String profileHeroBackgroundDefault =
      'assets/images/profile/$_pack/hero_background_default.png';

  /// 登录页顶部头图：仅浅黄主题复用「我的」页新版 Hero，其余主题保持原登录图。
  static const String authLoginTopBg = _pack == AppThemeId.yellowLight
      ? profileHeroBackgroundDefault
      : 'assets/images/auth/$_pack/login_top_bg.png';

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
  static const String bookDetailLike =
      'assets/icons/book_detail/shared/like.svg';
  static const String bookDetailLikeActive =
      'assets/icons/book_detail/shared/like_active.svg';
}
