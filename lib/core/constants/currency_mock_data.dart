import '../domain/entities/commerce_entities.dart';

/// 货币余额条 mock 数据（福利页 / 我的页共用 4 列）。
abstract final class CurrencyMockData {
  static const List<CurrencyBalance> welfareBalances = [
    CurrencyBalance(type: CurrencyType.energy, amount: 24839),
    CurrencyBalance(type: CurrencyType.wishStar, amount: 128),
    CurrencyBalance(type: CurrencyType.love, amount: 126),
    CurrencyBalance(type: CurrencyType.stardust, amount: 126),
  ];
}
