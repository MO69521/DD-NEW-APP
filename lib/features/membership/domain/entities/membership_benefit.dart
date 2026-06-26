import 'package:equatable/equatable.dart';

/// 会员权益项（图标 + 文案）。
class MembershipBenefit extends Equatable {
  const MembershipBenefit({
    required this.id,
    required this.iconAsset,
    required this.label,
  });

  final String id;
  final String iconAsset;
  final String label;

  @override
  List<Object?> get props => [id, iconAsset, label];
}
