import 'package:flutter/foundation.dart';

import '../domain/entities/member_account.dart';

/// 会员状态共享服务（App Shell 层）。
///
/// 作为当前用户身份 + VIP 状态的单一数据源，供 profile / welfare / membership /
/// account_settings 复用。`account` 为可监听值，昵称等资料变更后订阅方实时刷新。
/// 后续接入真实后端时仅替换实现，调用方无需改动。
abstract interface class MembershipStatusService {
  /// 当前用户账户（可监听，变更后通知订阅方）。
  ValueListenable<MemberAccount> get account;

  /// 拉取当前用户会员账户信息。
  Future<MemberAccount> fetchAccount();

  /// 开通 / 续费会员（mock：仅本地置为 VIP 并顺延有效期）。
  Future<MemberAccount> activate({required Duration period});

  /// 修改昵称（mock：本地更新并通知订阅方）。
  Future<MemberAccount> updateNickname(String nickname);
}

/// Mock 实现：内存维护一份账户状态，供演示与本地联调。
class MockMembershipStatusService implements MembershipStatusService {
  MockMembershipStatusService();

  final ValueNotifier<MemberAccount> _account = ValueNotifier<MemberAccount>(
    const MemberAccount(
      userId: '1013971429',
      nickname: '宇宙无敌美少女',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      isVip: false,
    ),
  );

  @override
  ValueListenable<MemberAccount> get account => _account;

  @override
  Future<MemberAccount> fetchAccount() async => _account.value;

  @override
  Future<MemberAccount> activate({required Duration period}) async {
    final base = _account.value.vipExpireAt ?? DateTime.now();
    _account.value = _account.value.copyWith(
      isVip: true,
      vipExpireAt: base.add(period),
    );
    return _account.value;
  }

  @override
  Future<MemberAccount> updateNickname(String nickname) async {
    _account.value = _account.value.copyWith(nickname: nickname);
    return _account.value;
  }
}
