/// 路由路径与名称常量，所有路由必须在此注册。
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String splashName = 'splash';

  static const String login = '/login';
  static const String loginName = 'login';

  static const String home = '/';
  static const String homeName = 'home';

  static const String ranking = '/ranking';
  static const String rankingName = 'ranking';

  static const String bookDetail = '/book/:id';
  static const String bookDetailName = 'bookDetail';
  static const String bookDiscussionDetail = '/book/:id/discussion/:postId';
  static const String bookDiscussionDetailName = 'bookDiscussionDetail';

  static const String search = '/search';
  static const String searchName = 'search';

  static const String category = '/category';
  static const String categoryName = 'category';

  static const String editorPick = '/editor-pick';
  static const String editorPickName = 'editorPick';

  static const String membership = '/membership';
  static const String membershipName = 'membership';
  static const String membershipBenefitsDetail = '/membership/benefits';
  static const String membershipBenefitsDetailName = 'membershipBenefitsDetail';

  static const String rechargeRecords = '/recharge-records';
  static const String rechargeRecordsName = 'rechargeRecords';

  static const String currencyWallet = '/currency/:type';
  static const String currencyWalletName = 'currencyWallet';
  static const String energyRecords = '/currency/energy/records';
  static const String energyRecordsName = 'energyRecords';

  static const String accountSettings = '/account-settings';
  static const String accountSettingsName = 'accountSettings';

  static const String dressUp = '/dress-up';
  static const String dressUpName = 'dressUp';

  static const String editNickname = '/account-settings/nickname';
  static const String editNicknameName = 'editNickname';

  static const String myMessages = '/my-messages';
  static const String myMessagesName = 'myMessages';

  static const String cardPack = '/card-pack';
  static const String cardPackName = 'cardPack';

  static const String helpFeedback = '/help-feedback';
  static const String helpFeedbackName = 'helpFeedback';
  static const String helpFeedbackFaqDetail = '/help-feedback/faq-detail';
  static const String helpFeedbackFaqDetailName = 'helpFeedbackFaqDetail';

  static const String settings = '/settings';
  static const String settingsName = 'settings';
  static const String notificationSettings = '/settings/notifications';
  static const String notificationSettingsName = 'notificationSettings';
  static const String personalizedAds = '/settings/personalized-ads';
  static const String personalizedAdsName = 'personalizedAds';
  static const String readingPreferences = '/settings/reading-preferences';
  static const String readingPreferencesName = 'readingPreferences';
  static const String teenMode = '/settings/teen-mode';
  static const String teenModeName = 'teenMode';
  static const String teenModePassword = '/settings/teen-mode/password';
  static const String teenModePasswordName = 'teenModePassword';
  static const String settingsDocument = '/settings/document/:type';
  static const String settingsDocumentName = 'settingsDocument';
}
