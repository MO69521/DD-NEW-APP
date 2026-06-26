/// 路由路径与名称常量，所有路由必须在此注册。
abstract final class AppRoutes {
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

  static const String membership = '/membership';
  static const String membershipName = 'membership';

  static const String rechargeRecords = '/recharge-records';
  static const String rechargeRecordsName = 'rechargeRecords';
}
