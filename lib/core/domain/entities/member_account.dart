import 'package:equatable/equatable.dart';

/// 跨 feature 共享的当前用户会员账户契约（纯 Dart）。
///
/// 由 `core/services` 的会员状态服务提供，profile / welfare / membership
/// 统一从该契约读取 VIP 状态与基础身份，避免各自重复 mock。
class MemberAccount extends Equatable {
  const MemberAccount({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
    this.isVip = false,
    this.vipExpireAt,
  });

  final String userId;
  final String nickname;
  final String avatarUrl;
  final bool isVip;
  final DateTime? vipExpireAt;

  MemberAccount copyWith({
    String? nickname,
    String? avatarUrl,
    bool? isVip,
    DateTime? vipExpireAt,
  }) {
    return MemberAccount(
      userId: userId,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVip: isVip ?? this.isVip,
      vipExpireAt: vipExpireAt ?? this.vipExpireAt,
    );
  }

  @override
  List<Object?> get props => [userId, nickname, avatarUrl, isVip, vipExpireAt];
}
