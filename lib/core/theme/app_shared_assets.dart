/// 跨主题共用的位图路径（空状态插图等）。
///
/// 与 [AppThemeAssets] 分工：后者管「随 THEME 变」的色稿 / 头图；
/// 本类放**三主题同一套**的插图。页面禁止裸写 `'assets/images/…'` 散落路径。
abstract final class AppSharedAssets {
  // ── empty_states · 空状态插图（三主题公用）──
  static const String emptyBookshelf =
      'assets/images/empty_states/empty_bookshelf.png';
  static const String emptyCardPack =
      'assets/images/empty_states/empty_card_pack.png';
  static const String emptyMessages =
      'assets/images/empty_states/empty_messages.png';
}
