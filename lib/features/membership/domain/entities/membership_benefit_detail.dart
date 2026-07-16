import 'package:equatable/equatable.dart';

/// 会员权益详情（含说明与示例图）。
class MembershipBenefitDetail extends Equatable {
  const MembershipBenefitDetail({
    required this.id,
    required this.iconAsset,
    required this.label,
    required this.description,
    required this.exampleImageAsset,
  });

  final String id;
  final String iconAsset;
  final String label;
  final String description;
  final String exampleImageAsset;

  @override
  List<Object?> get props => [
    id,
    iconAsset,
    label,
    description,
    exampleImageAsset,
  ];
}
