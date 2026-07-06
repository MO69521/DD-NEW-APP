/// 全局圆角 token，禁止在 UI 中写死 [BorderRadius.circular] 数值。
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;

  static const double coverSm = 6;

  /// 通用 CTA / 胶囊按钮圆角（多处 26 的单一真源）。
  static const double cta = 26;

  static const double rankingFullListAction = 22;
  static const double searchBar = 35;
  static const double navOuter = 47;
  static const double navInner = 38;

  static const double welfareVipBanner = 10;
  static const double welfareTaskBubble = 9;
  static const double welfareCheckInSection = lg;
  static const double welfareVipCta = 23;
  static const double welfareCheckInCta = cta;
  static const double welfareRechargePrice = cta;
  static const double welfareRechargeMoreAction = 22;

  static const double bookshelfReadingBanner = 45;
  static const double bookshelfClaimWelfareCta = 33;

  // 榜单详情页 (Figma 220:8376)
  static const double rankingSegmentedOuter = 46;
  static const double rankingSegmentedInner = 50;
  static const double rankingDimensionActive = 20;

  // 书籍详情页 (Figma 183:1874)
  static const double bookDetailTabBar = 46;
  static const double bookDetailTabItem = 50;
  static const double bookDetailCatalog = 10;
  static const double bookDetailCatalogDrawerCover = coverSm;
  static const double bookDetailReadCta = cta;
  static const double bookDetailCharFav = cta;
  static const double bookDetailDiscussionCard = md;
  static const double bookDetailDiscussionReply = sm;
  static const double bookDetailDiscussionFilter = 20;

  // 搜索页（深色态）
  static const double searchStatusBadge = xs;

  // 会员页 (Figma 927:725)
  static const double membershipCard = lg;
  static const double membershipPlanCard = 10;
  static const double membershipCta = cta;

  // 设置页
  static const double settingsLogo = xl;

  // 伙伴页 / 探索
  static const double partnerCategoryChip = sm;
  static const double partnerCharacterCard = md;
  static const double partnerTraitTag = xs;
  static const double partnerCollectionBadge = xs;
  static const double partnerNewBadge = xs;
  static const double partnerFilterSheet = lg;
}
