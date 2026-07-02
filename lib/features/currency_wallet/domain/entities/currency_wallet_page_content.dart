import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/commerce_entities.dart';

enum CurrencyWalletAction {
  recharge,
  wish,
  viewShop,
  viewGift,
  confess,
  exchange,
  welfare,
  detail,
  info,
}

class CurrencyObtainWay extends Equatable {
  const CurrencyObtainWay({
    required this.id,
    required this.title,
    required this.actionLabel,
    required this.action,
  });

  final String id;
  final String title;
  final String actionLabel;
  final CurrencyWalletAction action;

  @override
  List<Object?> get props => [id, title, actionLabel, action];
}

class CurrencyLedgerRecord extends Equatable {
  const CurrencyLedgerRecord({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.amountDelta,
  });

  final String id;
  final String title;
  final String timeLabel;
  final int amountDelta;

  @override
  List<Object?> get props => [id, title, timeLabel, amountDelta];
}

class CurrencyInfoSection extends Equatable {
  const CurrencyInfoSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  List<Object?> get props => [title, body];
}

class StardustExchangeOption extends Equatable {
  const StardustExchangeOption({
    required this.id,
    required this.energyAmount,
    required this.stardustCost,
    this.badgeLabel,
  });

  final String id;
  final int energyAmount;
  final int stardustCost;
  final String? badgeLabel;

  @override
  List<Object?> get props => [id, energyAmount, stardustCost, badgeLabel];
}

class CurrencyWalletPageContent extends Equatable {
  const CurrencyWalletPageContent({
    required this.type,
    required this.balance,
    this.obtainWays = const [],
    this.ledgerRecords = const [],
    this.rechargePackages = const [],
    this.stardustOptions = const [],
    this.ruleDescriptions = const [],
    this.infoSections = const [],
    this.primaryActionLabel,
    this.secondaryActionLabel,
  });

  final CurrencyType type;
  final int balance;
  final List<CurrencyObtainWay> obtainWays;
  final List<CurrencyLedgerRecord> ledgerRecords;
  final List<RechargePackage> rechargePackages;
  final List<StardustExchangeOption> stardustOptions;
  final List<String> ruleDescriptions;
  final List<CurrencyInfoSection> infoSections;
  final String? primaryActionLabel;
  final String? secondaryActionLabel;

  @override
  List<Object?> get props => [
    type,
    balance,
    obtainWays,
    ledgerRecords,
    rechargePackages,
    stardustOptions,
    ruleDescriptions,
    infoSections,
    primaryActionLabel,
    secondaryActionLabel,
  ];
}
