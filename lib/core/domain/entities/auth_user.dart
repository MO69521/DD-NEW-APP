import 'package:equatable/equatable.dart';

/// 登录用户基础资料，对齐后端用户信息响应。
class AuthUser extends Equatable {

  factory AuthUser.fromJson(Map<String, Object?> json) {
    return AuthUser(
      id: json['id'] as String,
      phone: json['phone'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );
  }
  const AuthUser({
    required this.id,
    required this.phone,
    required this.nickname,
    required this.avatarUrl,
  });

  final String id;
  final String phone;
  final String nickname;
  final String avatarUrl;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'phone': phone,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
    };
  }

  @override
  List<Object?> get props => [id, phone, nickname, avatarUrl];
}
