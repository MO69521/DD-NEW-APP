import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/service_locator.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_layout.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/bookstore/application/bookstore_cubit.dart';
import '../../features/bookstore/index.dart';
import '../../features/bookshelf/application/bookshelf_cubit.dart';
import '../../features/bookshelf/application/bookshelf_state.dart';
import '../../features/bookshelf/index.dart';
import '../../features/category/index.dart';
import '../../features/partner/application/partner_cubit.dart';
import '../../features/partner/index.dart';
import '../../features/profile/application/profile_cubit.dart';
import '../../features/profile/index.dart';
import '../../features/onboarding/index.dart';
import '../../features/ranking/index.dart';
import '../../features/welfare/application/welfare_cubit.dart';
import '../../features/welfare/index.dart';
import '../../features/welfare/presentation/components/check_in_success_dialog.dart';
import '../../features/welfare/presentation/components/daily_check_in_dialog.dart';
import '../../shared/components/app_toast.dart';
import '../../shared/components/energy_recharge_purchase_dialog.dart';
import '../../shared/layouts/app_bottom_nav.dart';
import '../../shared/layouts/main_tab_controller.dart';
import '../../shared/layouts/main_tab_shell.dart';
import '../app_router.dart';
import '../app_routes.dart';

/// 主 Tab Shell 页面：在 application 层注入各 Tab Cubit。
class MainTabShellPage extends StatefulWidget {
  const MainTabShellPage({
    super.key,
    this.initialIndex = 0,
    this.initialToastMessage,
    this.initialToastEventId,
    this.initialBookshelfTabIntent,
    this.initialBookstoreTopTabIntent,
  });

  final int initialIndex;
  final String? initialToastMessage;
  final String? initialToastEventId;
  final String? initialBookshelfTabIntent;
  final String? initialBookstoreTopTabIntent;

  @override
  State<MainTabShellPage> createState() => _MainTabShellPageState();
}

class _MainTabShellPageState extends State<MainTabShellPage> {
  final _mainTabController = MainTabController();

  @override
  void initState() {
    super.initState();
    _showRouteToast(widget.initialToastMessage);
    final intent = widget.initialBookshelfTabIntent;
    if (intent != null && intent.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mainTabController.openBookshelfTab(intent);
      });
    }
  }

  @override
  void didUpdateWidget(covariant MainTabShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialToastEventId != widget.initialToastEventId) {
      _showRouteToast(widget.initialToastMessage);
    }
  }

  void _showRouteToast(String? message) {
    if (message == null || message.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AppToast.show(context, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialBookstoreTopTab = _parseBookstoreTopTab(
      widget.initialBookstoreTopTabIntent,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = BookstoreCubit();
            if (initialBookstoreTopTab != null) {
              cubit.switchTopTab(initialBookstoreTopTab);
            }
            return cubit..load();
          },
        ),
        BlocProvider(create: (_) => WelfareCubit()..load()),
        BlocProvider(create: (_) => PartnerCubit()..load()),
        BlocProvider(create: (_) => BookshelfCubit()..load()),
        BlocProvider(create: (_) => ProfileCubit()..load()),
      ],
      child: _FirstLaunchDialogs(
        child: BlocSelector<BookshelfCubit, BookshelfState, bool>(
          selector: (state) => state.interaction.isManaging,
          builder: (context, isBookshelfManaging) {
            return MainTabShell(
              initialIndex: widget.initialIndex,
              controller: _mainTabController,
              hideBottomNav: isBookshelfManaging,
              pages: [
                BookstorePage(
                  mainTabController: _mainTabController,
                  categoryTabBuilder: (context) {
                    final topChrome =
                        AppLayout.chromeTopHeight(
                          context,
                          barHeight: AppSizes.bookstoreTopHeaderHeight,
                        ) +
                        AppSizes.categoryHeaderToFilterGap;
                    return BlocProvider(
                      create: (_) => CategoryCubit()..load(),
                      child: CategoryTabBody(
                        topScrollPadding: topChrome,
                        bottomScrollPadding:
                            AppBottomNav.barHeight + AppSpacing.xl,
                      ),
                    );
                  },
                  rankingTabBuilder: (context) => BlocProvider(
                    create: (_) => RankingCubit(
                      initialDimension: RankingDimension.recommend,
                    )..load(),
                    child: const RankingTabBody(embedded: true),
                  ),
                ),
                WelfarePage(
                  onRechargePackageTap: (package) =>
                      EnergyRechargePurchaseDialog.show(
                        context,
                        package: package,
                      ),
                ),
                const PartnerPage(),
                BookshelfPage(mainTabController: _mainTabController),
                ProfilePage(mainTabController: _mainTabController),
              ],
            );
          },
        ),
      ),
    );
  }

  BookstoreTopTab? _parseBookstoreTopTab(String? intent) {
    if (intent == null || intent.isEmpty) return null;
    for (final tab in BookstoreTopTab.values) {
      if (tab.name == intent) return tab;
    }
    return null;
  }
}

/// 新用户首启弹窗编排：性别 / 年龄收集 → 每日签到弹窗 → 签到成功弹窗。
///
/// 置于各 Tab Cubit provider 之下，以便读取 [WelfareCubit] 的签到数据。
class _FirstLaunchDialogs extends StatefulWidget {
  const _FirstLaunchDialogs({required this.child});

  final Widget child;

  @override
  State<_FirstLaunchDialogs> createState() => _FirstLaunchDialogsState();
}

class _FirstLaunchDialogsState extends State<_FirstLaunchDialogs> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runFirstLaunchFlow());
  }

  /// 仅新用户本会话首次进入首页触发：先收集性别/年龄，完成后弹出签到弹窗。
  Future<void> _runFirstLaunchFlow() async {
    if (!ServiceLocator.onboarding.needsBasicInfo) return;
    if (!mounted) return;

    await OnboardingProfileDialog.show(context);
    if (!mounted) return;

    // 与性别/年龄弹窗拉开时间间隔，避免关闭后立即紧接弹出显得突兀。
    await Future<void>.delayed(AppDurations.slow * 3);
    if (!mounted) return;

    final cubit = context.read<WelfareCubit>();
    final summary = cubit.checkInSummary;
    if (summary == null) return;

    await DailyCheckInDialog.show(
      context,
      summary: summary,
      onCheckIn: () {
        cubit.checkIn();
        if (!mounted) return;
        CheckInSuccessDialog.show(
          context,
          summary: summary,
          onVipClaim: () => AppRouter.pushNamed(AppRoutes.membershipName),
          onWatchVideo: () => AppToast.show(context, '视频功能开发中'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
