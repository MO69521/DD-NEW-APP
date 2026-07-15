import 'package:equatable/equatable.dart';

import '../../../../core/config/app_theme_id.dart';

/// 用户资料（头像 URL 由后端返回，非本地 asset）。
class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
    this.partnerAvatarUrls = const [],
    this.isVip = false,
    this.heroBackgroundAsset = defaultHeroBackgroundAsset,
  });

  /// 我的页 Hero 头部背景素材图（独立于头像，后续可换不同素材；按主题分包）。
  static const String defaultHeroBackgroundAsset =
      'assets/images/profile/${AppThemeId.assetPack}/hero_background_default.png';

  final String userId;
  final String nickname;
  final String avatarUrl;
  final List<String> partnerAvatarUrls;
  final bool isVip;

  /// Hero 头部背景素材图资源路径。
  final String heroBackgroundAsset;

  UserProfile copyWith({
    String? userId,
    String? nickname,
    String? avatarUrl,
    List<String>? partnerAvatarUrls,
    bool? isVip,
    String? heroBackgroundAsset,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      partnerAvatarUrls: partnerAvatarUrls ?? this.partnerAvatarUrls,
      isVip: isVip ?? this.isVip,
      heroBackgroundAsset: heroBackgroundAsset ?? this.heroBackgroundAsset,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    nickname,
    avatarUrl,
    partnerAvatarUrls,
    isVip,
    heroBackgroundAsset,
  ];
}
