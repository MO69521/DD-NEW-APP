import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/currency_config.dart';
import '../../core/domain/entities/commerce_entities.dart';
import '../../features/currency_wallet/index.dart';
import '../../features/membership/index.dart';
import '../app_routes.dart';

/// 会员与钱包路由：会员、权益详情、充值记录、货币钱包、能量明细。
List<RouteBase> membershipWalletRoutes() => [
  GoRoute(
    path: AppRoutes.membership,
    name: AppRoutes.membershipName,
    builder: (context, state) => BlocProvider(
      create: (_) => MembershipCubit()..load(),
      child: const MembershipPage(),
    ),
  ),
  GoRoute(
    path: AppRoutes.membershipBenefitsDetail,
    name: AppRoutes.membershipBenefitsDetailName,
    builder: (context, state) {
      final extra = state.extra;
      final initialIndex = extra is int ? extra : 0;
      return BlocProvider(
        create: (_) => MembershipBenefitsDetailCubit()..load(),
        child: MembershipBenefitsDetailPage(initialIndex: initialIndex),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.rechargeRecords,
    name: AppRoutes.rechargeRecordsName,
    builder: (context, state) => const RechargeRecordsPage(),
  ),
  GoRoute(
    path: AppRoutes.currencyWallet,
    name: AppRoutes.currencyWalletName,
    builder: (context, state) {
      final type =
          CurrencyConfig.fromSlug(state.pathParameters['type']) ??
          CurrencyType.energy;
      return BlocProvider(
        create: (_) => CurrencyWalletCubit(type)..load(),
        child: const CurrencyWalletPage(),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.energyRecords,
    name: AppRoutes.energyRecordsName,
    builder: (context, state) => BlocProvider(
      create: (_) => EnergyRecordsCubit()..load(),
      child: const EnergyRecordsPage(),
    ),
  ),
];
