import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/app_async_page_body.dart';
import '../../../../shared/components/app_tab_top_texture.dart';
import '../../../../shared/components/blurred_pinned_header_delegate.dart';
import '../../../../shared/components/currency_balance_bar.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/components/recharge_packages_section.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../application/welfare_cubit.dart';
import '../../application/welfare_state.dart';
import '../../domain/entities/welfare_models.dart';
import '../../domain/entities/welfare_page_content.dart';
import '../components/check_in_success_dialog.dart';
import '../components/daily_check_in_section.dart';
import '../components/meal_check_in_section.dart';
import '../components/reading_vip_progress_section.dart';
import '../components/welfare_rules_dialog.dart';
import '../components/welfare_task_list_section.dart';
import '../components/welfare_page_header.dart';
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
        final content = state.domain.content;
        if (state.ui.isLoading ||
            state.ui.errorMessage != null ||
            content == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: AppAsyncPageBody(
              isLoading: state.ui.isLoading,
              errorMessage: state.ui.errorMessage,
              onRetry: () => context.read<WelfareCubit>().load(),
              isEmpty: content == null,
              child: const SizedBox.shrink(),
            ),
          );
        }

        return _WelfareView(
          content: content,
          hasCheckedInToday: state.ui.hasCheckedInToday,
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
    required this.hasCheckedInToday,
    this.onRechargePackageTap,
    this.onRechargeMoreTap,
  });

  final WelfarePageContent content;
  final bool hasCheckedInToday;
  final ValueChanged<RechargePackage>? onRechargePackageTap;
  final VoidCallback? onRechargeMoreTap;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final cubit = context.read<WelfareCubit>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          const AppTabTopTexture(),
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: BlurredPinnedHeaderDelegate(
                  height: statusBarHeight + AppSizes.welfareHeaderHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: statusBarHeight),
                      WelfarePageHeader(
                        onRechargeInfoTap: () => showAppBlurredDialog<void>(
                          context: context,
                          builder: (_) => const WelfareRulesDialog(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppSpacing.md),
                    CurrencyBalanceBar(
                      balances: content.currencyBalances,
                      onCurrencyTap: cubit.onCurrencyTap,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    RechargePackagesSection(
                      packages: content.rechargePackages,
                      onPackageTap: onRechargePackageTap,
                      onMoreTap: onRechargeMoreTap,
                      collapsible: true,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DailyCheckInSection(
                      summary: content.checkInSummary,
                      checkedIn: hasCheckedInToday,
                      onCheckInTap: () {
                        cubit.checkIn();
                        CheckInSuccessDialog.show(
                          context,
                          summary: content.checkInSummary,
                          onVipClaim: () =>
                              AppRouter.pushNamed(AppRoutes.membershipName),
                          onWatchVideo: () => _showWatchVideoToast(context),
                        );
                      },
                      onWatchVideoTap: () => _showWatchVideoToast(context),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    MealCheckInSection(
                      summary: content.mealCheckInSummary,
                      onVipClaimTap: () =>
                          AppRouter.pushNamed(AppRoutes.membershipName),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ReadingVipProgressSection(
                      task: content.featuredReadingReward,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    WelfareTaskListSection(
                      summary: content.taskListSummary,
                      onVipTap: () =>
                          AppRouter.pushNamed(AppRoutes.membershipName),
                    ),
                    const SizedBox(height: WelfarePage._bottomNavReserve),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showWatchVideoToast(BuildContext context) {
    AppToast.show(context, '视频功能开发中');
  }
}
