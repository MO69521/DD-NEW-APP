import '../domain/entities/commerce_entities.dart';

/// 货币余额条 mock 数据（福利页 / 我的页共用 4 列）。
abstract final class CurrencyMockData {
  static const List<CurrencyBalance> welfareBalances = [
    CurrencyBalance(type: CurrencyType.energy, amount: 1288),
    CurrencyBalance(type: CurrencyType.wishStar, amount: 66),
    CurrencyBalance(type: CurrencyType.love, amount: 26),
    CurrencyBalance(type: CurrencyType.stardust, amount: 12),
  ];
}
