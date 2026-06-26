import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/currency_balance_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/components/recharge_packages_section.dart';
import '../../../../shared/components/vip_promo_banner.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/welfare_cubit.dart';
import '../../application/welfare_state.dart';
import '../../domain/entities/welfare_models.dart';
import '../../domain/entities/welfare_page_content.dart';
import '../components/daily_check_in_section.dart';
import '../components/meal_check_in_section.dart';
import '../components/reading_vip_progress_section.dart';
import '../components/welfare_task_list_section.dart';
import '../components/welfare_page_header.dart';
import 'recharge_detail_page.dart';
import '../../../../core/theme/app_colors.dart';

/// 福利中心页（Figma 294:4943）：仅渲染 state、触发 action。
class WelfarePage extends StatelessWidget {
  const WelfarePage({
    super.key,
    this.onRechargePackageTap,
    this.onRechargeMoreTap,
  });

  final ValueChanged<RechargePackage>? onRechargePackageTap;
  final VoidCallback? onRechargeMoreTap;

  static const double _bottomNavReserve =
      AppBottomNav.barHeight + AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelfareCubit, WelfareState>(
      buildWhen: (previous, current) =>
          previous.ui != current.ui || previous.domain != current.domain,
      builder: (context, state) {
        if (state.ui.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.ui.errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: EmptyState(
              title: '加载失败',
              description: state.ui.errorMessage,
              action: AppButton(
                label: '重试',
                onPressed: () => context.read<WelfareCubit>().load(),
              ),
            ),
          );
        }

        final content = state.domain.content;
        if (content == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: const EmptyState(title: '暂无数据'),
          );
        }

        return _WelfareView(
          content: content,
          onRechargePackageTap: onRechargePackageTap,
          onRechargeMoreTap: onRechargeMoreTap,
        );
      },
    );
  }
}

class _WelfareView extends StatelessWidget {
  const _WelfareView({
    required this.content,
    this.onRechargePackageTap,
    this.onRechargeMoreTap,
  });

  final WelfarePageContent content;
  final ValueChanged<RechargePackage>? onRechargePackageTap;
  final VoidCallback? onRechargeMoreTap;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final statusBarHeight = topInset > 0
        ? topInset
        : AppSizes.statusBarPlaceholderHeight;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _WelfareHeaderDelegate(
              height: statusBarHeight + AppSizes.welfareHeaderHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: statusBarHeight),
                  const WelfarePageHeader(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.md),
                CurrencyBalanceBar(balances: content.currencyBalances),
                const SizedBox(height: AppSpacing.sm),
                VipPromoBanner(
                  monthlyEnergy: content.vipMonthlyEnergy,
                  priceYuan: content.vipPriceYuan,
                  onTap: () =>
                      AppRouter.pushNamed(AppRoutes.membershipName),
                ),
                const SizedBox(height: AppSpacing.sm),
                RechargePackagesSection(
                  packages: content.rechargePackages,
                  onPackageTap: onRechargePackageTap,
                  onMoreTap: onRechargeMoreTap,
                  detailPageBuilder: (context, package, closeContainer) =>
                      RechargeDetailPage(
                        package: package,
                        onClose: closeContainer,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                DailyCheckInSection(summary: content.checkInSummary),
                const SizedBox(height: AppSpacing.sm),
                MealCheckInSection(summary: content.mealCheckInSummary),
                const SizedBox(height: AppSpacing.sm),
                ReadingVipProgressSection(task: content.featuredReadingReward),
                const SizedBox(height: AppSpacing.sm),
                WelfareTaskListSection(summary: content.taskListSummary),
                const SizedBox(height: WelfarePage._bottomNavReserve),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelfareHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _WelfareHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.backgroundDark, child: child);
  }

  @override
  bool shouldRebuild(covariant _WelfareHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
