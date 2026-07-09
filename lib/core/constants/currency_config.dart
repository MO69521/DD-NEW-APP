import '../domain/entities/commerce_entities.dart';

/// 虚拟货币 icon / 文案静态配置（App Shell 层，供多 feature 复用）。
abstract final class CurrencyConfig {
  /// 我的页 / 福利页货币条展示的币种（4 列）。
  static const List<CurrencyType> profileBarTypes = [
    CurrencyType.energy,
    CurrencyType.wishStar,
    CurrencyType.love,
    CurrencyType.stardust,
  ];

  /// 福利页货币条展示的币种（4 列）。
  static const List<CurrencyType> welfareBarTypes = profileBarTypes;

  static String iconAsset(CurrencyType type) {
    return switch (type) {
      CurrencyType.energy => 'assets/icons/welfare/energy.svg',
      CurrencyType.wishStar => 'assets/icons/welfare/wish_star.png',
      CurrencyType.love => 'assets/icons/welfare/love.png',
      CurrencyType.stardust => 'assets/icons/welfare/stardust.png',
    };
  }

  static String label(CurrencyType type) {
    return switch (type) {
      CurrencyType.energy => '能量',
      CurrencyType.wishStar => '祈愿星',
      CurrencyType.love => '爱心',
      CurrencyType.stardust => '星尘',
    };
  }

  static String slug(CurrencyType type) {
    return switch (type) {
      CurrencyType.energy => 'energy',
      CurrencyType.wishStar => 'wish-star',
      CurrencyType.love => 'love',
      CurrencyType.stardust => 'stardust',
    };
  }

  static CurrencyType? fromSlug(String? slug) {
    return switch (slug) {
      'energy' => CurrencyType.energy,
      'wish-star' => CurrencyType.wishStar,
      'love' => CurrencyType.love,
      'stardust' => CurrencyType.stardust,
      _ => null,
    };
  }
}
