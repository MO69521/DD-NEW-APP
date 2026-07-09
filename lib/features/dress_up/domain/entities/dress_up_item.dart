import 'package:equatable/equatable.dart';

/// 单个装扮项（背景 / 头像 / 挂件 / 称号）。
class DressUpItem extends Equatable {
  const DressUpItem({
    required this.id,
    required this.name,
    this.thumbnailAsset = '',
    this.validityLabel = '',
    this.isEquipped = false,
  });

  final String id;
  final String name;

  /// 预览缩略图资源；为空时展示占位。
  final String thumbnailAsset;

  /// 有效期 / 说明文案（如「有效期：永久」「恢复默认背景」）。
  final String validityLabel;

  /// 当前是否已装扮。
  final bool isEquipped;

  @override
  List<Object?> get props => [
    id,
    name,
    thumbnailAsset,
    validityLabel,
    isEquipped,
  ];
}
