import 'package:equatable/equatable.dart';

import 'welfare_models.dart';

/// 福利页聚合数据契约。
class WelfarePageContent extends Equatable {
  const WelfarePageContent({
    required this.pendingClaimEnergy,
    required this.currencyBalances,
    required this.vipMonthlyEnergy,
    required this.vipPriceYuan,
    required this.rechargePackages,
    required this.checkInSummary,
    required this.readingWelfareSummary,
    required this.mealCheckInSummary,
    required this.featuredReadingReward,
    required this.taskListSummary,
  });

  /// 底部福利菜单展示的待领取能量，由服务端返回。
  final int pendingClaimEnergy;
  final List<CurrencyBalance> currencyBalances;
  final int vipMonthlyEnergy;
  final double vipPriceYuan;
  final List<RechargePackage> rechargePackages;
  final CheckInSummary checkInSummary;
  final ReadingWelfareSummary readingWelfareSummary;
  final MealCheckInSummary mealCheckInSummary;
  final WelfareTaskItem featuredReadingReward;
  final WelfareTaskListSummary taskListSummary;

  @override
  List<Object?> get props => [
    pendingClaimEnergy,
    currencyBalances,
    vipMonthlyEnergy,
    vipPriceYuan,
    rechargePackages,
    checkInSummary,
    readingWelfareSummary,
    mealCheckInSummary,
    featuredReadingReward,
    taskListSummary,
  ];
}
