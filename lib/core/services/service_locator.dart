import 'bookshelf_membership_service.dart';
import 'membership_status_service.dart';

/// 全局服务注册入口，跨 feature 共享服务通过此处暴露。
///
/// 后续可替换为 get_it / riverpod 等 DI 方案。
abstract final class ServiceLocator {
  static bool _initialized = false;

  static MembershipStatusService? _membershipStatus;
  static BookshelfMembershipService? _bookshelfMembership;

  /// 会员状态共享服务（单例）。
  static MembershipStatusService get membershipStatus =>
      _membershipStatus ??= MockMembershipStatusService();

  /// 书架状态共享服务（单例）。
  static BookshelfMembershipService get bookshelfMembership =>
      _bookshelfMembership ??= BookshelfMembershipService();

  static Future<void> init() async {
    if (_initialized) return;
    _membershipStatus ??= MockMembershipStatusService();
    _bookshelfMembership ??= BookshelfMembershipService();
    _initialized = true;
  }
}
