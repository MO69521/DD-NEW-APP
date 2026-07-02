import 'package:equatable/equatable.dart';

import 'account_security_binding.dart';

/// 账号设置页聚合数据。
class AccountSettingsPageContent extends Equatable {
  const AccountSettingsPageContent({
    required this.avatarUrl,
    required this.nickname,
    required this.userId,
    required this.securityBindings,
  });

  final String avatarUrl;
  final String nickname;
  final String userId;
  final List<AccountSecurityBinding> securityBindings;

  @override
  List<Object?> get props => [avatarUrl, nickname, userId, securityBindings];
}
