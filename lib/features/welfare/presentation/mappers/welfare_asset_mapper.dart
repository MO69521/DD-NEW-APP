import '../../../../core/constants/currency_config.dart';
import '../../domain/entities/welfare_models.dart';

/// 福利页展示层资源映射（Figma 541:10757 切图）。
abstract final class WelfareAssetMapper {
  static String rechargeIllustrationAsset(String packageId) {
    final tier = switch (packageId) {
      'rp1' => 1,
      'rp2' => 2,
      'rp3' => 3,
      'rp4' => 4,
      'rp5' => 5,
      'rp6' => 6,
      _ => 1,
    };
    return 'assets/images/welfare/recharge_tier_$tier.png';
  }

  static String currencyIconAsset(CurrencyType type) =>
      CurrencyConfig.iconAsset(type);

  static String currencyLabel(CurrencyType type) => CurrencyConfig.label(type);

  static String checkInRewardIconAsset(CheckInRewardType type) {
    return switch (type) {
      // 能量图标全局统一为 energy.svg（矢量，按使用尺寸缩放不失真）。
      CheckInRewardType.energy => 'assets/icons/welfare/energy.svg',
      // 星尘图标全局统一为 stardust.png（与货币条星尘共用同一张切图）。
      CheckInRewardType.stardust => 'assets/icons/welfare/stardust.png',
      CheckInRewardType.freeCard => 'assets/icons/welfare/free_card.png',
    };
  }

  /// 福利任务奖励图标；muted（已领取淡化）时星尘用灰色切图。
  static String taskRewardIconAsset(
    CheckInRewardType type, {
    bool isMuted = false,
  }) {
    if (type == CheckInRewardType.stardust && isMuted) {
      return 'assets/icons/welfare/task_stardust_gray.png';
    }
    return checkInRewardIconAsset(type);
  }

  /// 任务标题前的「热门」火苗图标。
  static String taskPopularIconAsset() =>
      'assets/icons/welfare/task_popular.svg';

  /// 任务按钮播放图标。
  static String taskVideoIconAsset() => 'assets/icons/welfare/task_video.svg';

  /// 里程碑气泡底图（46 / 48 宽，含指向节点的尾巴）。
  static String checkInMilestoneBubbleAsset({required bool isWide}) {
    return isWide
        ? 'assets/images/welfare/slices/milestone_bubble_wide.svg'
        : 'assets/images/welfare/slices/milestone_bubble.svg';
  }

  /// 进度条节点圆点。
  static String checkInMilestoneDotAsset() =>
      'assets/images/welfare/slices/milestone_dot.svg';

  /// 气泡内能量图标（全局统一 energy.svg，矢量按尺寸缩放）。
  static String checkInMilestoneEnergyIconAsset() =>
      'assets/icons/welfare/energy.svg';
}
