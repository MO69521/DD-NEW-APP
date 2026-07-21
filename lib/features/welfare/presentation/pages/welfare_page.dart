import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/main_tab_config.dart';
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
import '../components/reading_welfare_rules_dialog.dart';
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
    this.onGoReadTap,
  });

  final ValueChanged<RechargePackage>? onRechargePackageTap;
  final VoidCallback? onRechargeMoreTap;
  final VoidCallback? onGoReadTap;

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
          onGoReadTap: onGoReadTap,
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
    this.onGoReadTap,
  });

  final WelfarePageContent content;
  final bool hasCheckedInToday;
  final ValueChanged<RechargePackage>? onRechargePackageTap;
  final VoidCallback? onRechargeMoreTap;
  final VoidCallback? onGoReadTap;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final cubit = context.read<WelfareCubit>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // 福利页头部装饰渐变加高（用户指定 300）。
          const AppTabTopTexture(height: AppSizes.welfareTabTopTextureHeight),
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
                      useTransparentYellowLightStyle: true,
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
                      onInfoTap: () => showAppBlurredDialog<void>(
                        context: context,
                        builder: (_) => const ReadingWelfareRulesDialog(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    WelfareTaskListSection(
                      summary: content.taskListSummary,
                      onTaskActionTap: (task) =>
                          _handleTaskAction(context, cubit, task),
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

  void _handleTaskAction(
    BuildContext context,
    WelfareCubit cubit,
    WelfareTaskItem task,
  ) {
    switch (task.action.type) {
      case WelfareTaskActionType.vipClaim:
        AppRouter.pushNamed(AppRoutes.membershipName);
        return;
      case WelfareTaskActionType.watchVideo:
        _showWatchVideoToast(context);
        return;
      case WelfareTaskActionType.goRead:
        final onTap = onGoReadTap;
        if (onTap != null) {
          onTap();
        } else {
          AppRouter.goMainTab(MainTabConfig.bookstoreIndex);
        }
        return;
      case WelfareTaskActionType.checkIn:
        AppToast.show(context, '签到功能开发中');
        return;
      case WelfareTaskActionType.claimReward:
        AppToast.show(context, '领取成功');
        return;
      case WelfareTaskActionType.open:
        AppRouter.pushNamed(AppRoutes.notificationSettingsName);
        return;
      case WelfareTaskActionType.recharge:
        cubit.onCurrencyTap(CurrencyType.energy);
        return;
    }
  }
}
