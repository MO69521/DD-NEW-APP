/// 路由路径与名称常量，所有路由必须在此注册。
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String splashName = 'splash';

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

  static const String rechargeRecords = '/recharge-records';
  static const String rechargeRecordsName = 'rechargeRecords';

  static const String currencyWallet = '/currency/:type';
  static const String currencyWalletName = 'currencyWallet';
  static const String energyRecords = '/currency/energy/records';
  static const String energyRecordsName = 'energyRecords';

  static const String accountSettings = '/account-settings';
  static const String accountSettingsName = 'accountSettings';

  static const String myMessages = '/my-messages';
  static const String myMessagesName = 'myMessages';

  static const String helpFeedback = '/help-feedback';
  static const String helpFeedbackName = 'helpFeedback';
  static const String helpFeedbackFaqDetail = '/help-feedback/faq-detail';
  static const String helpFeedbackFaqDetailName = 'helpFeedbackFaqDetail';

  static const String settings = '/settings';
  static const String settingsName = 'settings';
}
