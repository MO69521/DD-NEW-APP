/// 跨主题共用的位图路径（空状态插图等）。
///
/// 与 [AppThemeAssets] 分工：后者管「随 THEME 变」的色稿 / 头图；
/// 本类放**三主题同一套**的插图。页面禁止裸写 `'assets/images/…'` 散落路径。
abstract final class AppSharedAssets {
  // ── bookstore · 书城刷新动画（三主题公用）──
  static const List<String> bookstoreRefreshBearFrames = [
    'assets/images/bookstore/refresh_bear/frame_01.png',
    'assets/images/bookstore/refresh_bear/frame_02.png',
    'assets/images/bookstore/refresh_bear/frame_03.png',
    'assets/images/bookstore/refresh_bear/frame_04.png',
    'assets/images/bookstore/refresh_bear/frame_05.png',
    'assets/images/bookstore/refresh_bear/frame_06.png',
    'assets/images/bookstore/refresh_bear/frame_07.png',
    'assets/images/bookstore/refresh_bear/frame_08.png',
    'assets/images/bookstore/refresh_bear/frame_09.png',
    'assets/images/bookstore/refresh_bear/frame_10.png',
    'assets/images/bookstore/refresh_bear/frame_11.png',
    'assets/images/bookstore/refresh_bear/frame_12.png',
    'assets/images/bookstore/refresh_bear/frame_13.png',
    'assets/images/bookstore/refresh_bear/frame_14.png',
    'assets/images/bookstore/refresh_bear/frame_15.png',
    'assets/images/bookstore/refresh_bear/frame_16.png',
    'assets/images/bookstore/refresh_bear/frame_17.png',
    'assets/images/bookstore/refresh_bear/frame_18.png',
    'assets/images/bookstore/refresh_bear/frame_19.png',
    'assets/images/bookstore/refresh_bear/frame_20.png',
  ];

  // ── empty_states · 空状态插图（三主题公用）──
  static const String emptyBookshelf =
      'assets/images/empty_states/empty_bookshelf.png';
  static const String emptyCardPack =
      'assets/images/empty_states/empty_card_pack.png';
  static const String emptyMessages =
      'assets/images/empty_states/empty_messages.png';
}
