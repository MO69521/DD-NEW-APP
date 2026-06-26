import 'package:equatable/equatable.dart';

/// 会员页交互状态：套餐选中项与购买进行态/结果提示。
class MembershipInteractionState extends Equatable {
  const MembershipInteractionState({
    this.selectedPlanId,
    this.isPurchasing = false,
    this.purchaseMessage,
  });

  final String? selectedPlanId;
  final bool isPurchasing;

  /// 一次性购买结果提示，展示后由 cubit 清空。
  final String? purchaseMessage;

  MembershipInteractionState copyWith({
    String? selectedPlanId,
    bool? isPurchasing,
    String? purchaseMessage,
    bool clearMessage = false,
  }) {
    return MembershipInteractionState(
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      purchaseMessage: clearMessage
          ? null
          : purchaseMessage ?? this.purchaseMessage,
    );
  }

  @override
  List<Object?> get props => [selectedPlanId, isPurchasing, purchaseMessage];
}
