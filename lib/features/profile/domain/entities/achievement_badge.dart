import 'package:equatable/equatable.dart';

/// 我的成就·勋章领域实体（纯 Dart）。
class AchievementBadge extends Equatable {
  const AchievementBadge({
    required this.id,
    required this.name,
    required this.iconAsset,
  });

  final String id;
  final String name;
  final String iconAsset;

  @override
  List<Object?> get props => [id, name, iconAsset];
}
