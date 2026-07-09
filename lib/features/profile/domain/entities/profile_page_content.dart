import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/commerce_entities.dart';
import 'achievement_badge.dart';
import 'profile_menu_item.dart';
import 'user_profile.dart';

/// 我的页聚合数据契约。
class ProfilePageContent extends Equatable {
  const ProfilePageContent({
    required this.user,
    required this.currencyBalances,
    required this.vipMonthlyEnergy,
    required this.vipPriceYuan,
    required this.rechargePackages,
    required this.freeClaimOptions,
    required this.achievementCount,
    required this.achievementBadges,
    required this.menuItems,
  });

  final UserProfile user;
  final List<CurrencyBalance> currencyBalances;
  final int vipMonthlyEnergy;
  final double vipPriceYuan;
  final List<RechargePackage> rechargePackages;
  final List<EnergyFreeClaimOption> freeClaimOptions;

  /// 已获得勋章总数。
  final int achievementCount;

  /// 勋章缩略图（展示用，通常取最近几枚）。
  final List<AchievementBadge> achievementBadges;
  final List<ProfileMenuItem> menuItems;

  ProfilePageContent copyWith({UserProfile? user}) {
    return ProfilePageContent(
      user: user ?? this.user,
      currencyBalances: currencyBalances,
      vipMonthlyEnergy: vipMonthlyEnergy,
      vipPriceYuan: vipPriceYuan,
      rechargePackages: rechargePackages,
      freeClaimOptions: freeClaimOptions,
      achievementCount: achievementCount,
      achievementBadges: achievementBadges,
      menuItems: menuItems,
    );
  }

  @override
  List<Object?> get props => [
    user,
    currencyBalances,
    vipMonthlyEnergy,
    vipPriceYuan,
    rechargePackages,
    freeClaimOptions,
    achievementCount,
    achievementBadges,
    menuItems,
  ];
}
