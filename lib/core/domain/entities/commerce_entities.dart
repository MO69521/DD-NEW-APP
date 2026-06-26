import 'package:equatable/equatable.dart';

/// 跨 feature 共享的虚拟货币与充值套餐契约（纯 Dart）。
enum CurrencyType {
  energy,
  wishStar,
  love,
  stardust,
}

class CurrencyBalance extends Equatable {
  const CurrencyBalance({required this.type, required this.amount});

  final CurrencyType type;
  final int amount;

  @override
  List<Object?> get props => [type, amount];
}

class RechargePackage extends Equatable {
  const RechargePackage({
    required this.id,
    required this.energyAmount,
    required this.originalAmount,
    required this.priceYuan,
    this.badgeLabel,
    this.illustrationAsset = 'assets/images/welfare/recharge_tier_1.png',
    this.actionRoute,
  });

  final String id;
  final int energyAmount;
  final int originalAmount;
  final int priceYuan;
  final String? badgeLabel;
  final String illustrationAsset;
  final String? actionRoute;

  @override
  List<Object?> get props => [
    id,
    energyAmount,
    originalAmount,
    priceYuan,
    badgeLabel,
    illustrationAsset,
    actionRoute,
  ];
}
