import '../domain/entities/member_account.dart';

/// 会员状态共享服务（App Shell 层）。
///
/// 作为当前用户 VIP 状态的单一数据源，供 profile / welfare / membership 复用。
/// 后续接入真实后端时仅替换实现，调用方无需改动。
abstract interface class MembershipStatusService {
  /// 拉取当前用户会员账户信息。
  Future<MemberAccount> fetchAccount();

  /// 开通 / 续费会员（mock：仅本地置为 VIP 并顺延有效期）。
  Future<MemberAccount> activate({required Duration period});
}

/// Mock 实现：内存维护一份账户状态，供演示与本地联调。
class MockMembershipStatusService implements MembershipStatusService {
  MockMembershipStatusService();

  MemberAccount _account = const MemberAccount(
    userId: '1013971429',
    nickname: '宇宙无敌美少女',
    avatarUrl: 'https://i.pravatar.cc/150?img=47',
    isVip: false,
  );

  @override
  Future<MemberAccount> fetchAccount() async => _account;

  @override
  Future<MemberAccount> activate({required Duration period}) async {
    final base = _account.vipExpireAt ?? DateTime.now();
    _account = _account.copyWith(isVip: true, vipExpireAt: base.add(period));
    return _account;
  }
}
