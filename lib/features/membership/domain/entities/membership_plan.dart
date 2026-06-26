import 'package:equatable/equatable.dart';

/// 会员套餐（连续包月首月 / 月卡 / 年卡 / 季卡 等）。
class MembershipPlan extends Equatable {
  const MembershipPlan({
    required this.id,
    required this.title,
    required this.priceText,
    required this.secondaryText,
    required this.cumulativeEnergy,
    this.isAutoRenew = false,
    this.renewHint,
    this.durationDays = 30,
  });

  final String id;
  final String title;

  /// 价格显示文案（保留设计原样，如「6.80」「15.0」「108.0」）。
  final String priceText;

  /// 价格下方副文案（删除线），如「次月起¥12.0/月」或「¥ 30.0」。
  final String secondaryText;

  /// 累计可得能量，底栏展示为「累计{n}能量」。
  final int cumulativeEnergy;

  /// 是否为连续订阅（影响续费提示与协议展示）。
  final bool isAutoRenew;

  /// 续费提示文案，如「首月仅要4.9元，到期按8.8元自动续费」。
  final String? renewHint;

  /// 套餐时长（天），用于 mock 顺延有效期。
  final int durationDays;

  @override
  List<Object?> get props => [
    id,
    title,
    priceText,
    secondaryText,
    cumulativeEnergy,
    isAutoRenew,
    renewHint,
    durationDays,
  ];
}
