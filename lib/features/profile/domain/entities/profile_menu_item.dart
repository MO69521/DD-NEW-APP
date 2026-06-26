import 'package:equatable/equatable.dart';

/// 我的页底部功能入口标识。
enum ProfileMenuAction {
  readingHistory,
  helpFeedback,
  qqGroup,
  settings,
  cardPack,
  dressUp,
  cardAlbum,
}

/// 功能入口配置（icon 静态，label 可由后端覆盖）。
class ProfileMenuItem extends Equatable {
  const ProfileMenuItem({
    required this.action,
    required this.label,
    required this.iconAsset,
  });

  final ProfileMenuAction action;
  final String label;
  final String iconAsset;

  @override
  List<Object?> get props => [action, label, iconAsset];
}
