import 'package:equatable/equatable.dart';

/// 互动 Tab 全屏竖滑场景。
class PartnerInteractionScene extends Equatable {
  const PartnerInteractionScene({
    required this.id,
    required this.characterId,
    required this.characterName,
    required this.backgroundAsset,
    required this.affectionLevel,
    required this.upgradeHint,
    required this.sceneIndex,
    required this.totalScenes,
  });

  final String id;
  final String characterId;
  final String characterName;
  final String backgroundAsset;
  final int affectionLevel;
  final String upgradeHint;
  final int sceneIndex;
  final int totalScenes;

  @override
  List<Object?> get props => [
        id,
        characterId,
        characterName,
        backgroundAsset,
        affectionLevel,
        upgradeHint,
        sceneIndex,
        totalScenes,
      ];
}
