import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/commerce_entities.dart';
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
    required this.menuItems,
  });

  final UserProfile user;
  final List<CurrencyBalance> currencyBalances;
  final int vipMonthlyEnergy;
  final double vipPriceYuan;
  final List<RechargePackage> rechargePackages;
  final List<ProfileMenuItem> menuItems;

  @override
  List<Object?> get props => [
    user,
    currencyBalances,
    vipMonthlyEnergy,
    vipPriceYuan,
    rechargePackages,
    menuItems,
  ];
}
