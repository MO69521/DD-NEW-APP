import 'package:equatable/equatable.dart';

/// 用户资料（头像 URL 由后端返回，非本地 asset）。
class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
    this.partnerAvatarUrls = const [],
    this.isVip = false,
  });

  final String userId;
  final String nickname;
  final String avatarUrl;
  final List<String> partnerAvatarUrls;
  final bool isVip;

  @override
  List<Object?> get props => [
    userId,
    nickname,
    avatarUrl,
    partnerAvatarUrls,
    isVip,
  ];
}
