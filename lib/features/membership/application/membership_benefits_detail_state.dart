import 'package:equatable/equatable.dart';

import '../domain/entities/membership_benefit_detail.dart';

/// 会员特权详情页状态：权益详情列表与加载态。
class MembershipBenefitsDetailState extends Equatable {
  const MembershipBenefitsDetailState({
    this.benefits = const [],
    this.isLoading = true,
  });

  final List<MembershipBenefitDetail> benefits;
  final bool isLoading;

  MembershipBenefitsDetailState copyWith({
    List<MembershipBenefitDetail>? benefits,
    bool? isLoading,
  }) {
    return MembershipBenefitsDetailState(
      benefits: benefits ?? this.benefits,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [benefits, isLoading];
}
