import 'package:equatable/equatable.dart';

import 'auth_user.dart';

/// 登录会话，对齐后端登录响应中的 token 与用户资料。
class AuthSession extends Equatable {

  factory AuthSession.fromJson(Map<String, Object?> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      user: AuthUser.fromJson(json['user'] as Map<String, Object?>),
    );
  }
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final AuthUser user;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, Object?> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, user];
}
