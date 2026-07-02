import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/commerce_entities.dart';

class CurrencyWalletInteractionState extends Equatable {
  const CurrencyWalletInteractionState({
    this.selectedEnergyOptionId = 'rp1',
    this.selectedPaymentMethod = PaymentMethod.wechat,
    this.selectedStardustOptionId = 'stardust_5',
  });

  final String selectedEnergyOptionId;
  final PaymentMethod selectedPaymentMethod;
  final String selectedStardustOptionId;

  CurrencyWalletInteractionState copyWith({
    String? selectedEnergyOptionId,
    PaymentMethod? selectedPaymentMethod,
    String? selectedStardustOptionId,
  }) {
    return CurrencyWalletInteractionState(
      selectedEnergyOptionId:
          selectedEnergyOptionId ?? this.selectedEnergyOptionId,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedStardustOptionId:
          selectedStardustOptionId ?? this.selectedStardustOptionId,
    );
  }

  @override
  List<Object?> get props => [
    selectedEnergyOptionId,
    selectedPaymentMethod,
    selectedStardustOptionId,
  ];
}
