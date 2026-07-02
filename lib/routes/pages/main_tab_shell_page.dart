import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../../features/ranking/index.dart';
import '../../features/welfare/application/welfare_cubit.dart';
import '../../features/welfare/index.dart';
import '../../shared/components/energy_recharge_purchase_dialog.dart';
import '../../shared/layouts/app_bottom_nav.dart';
import '../../shared/layouts/main_tab_controller.dart';
import '../../shared/layouts/main_tab_shell.dart';

/// 主 Tab Shell 页面：在 application 层注入各 Tab Cubit。
class MainTabShellPage extends StatefulWidget {
  const MainTabShellPage({
    super.key,
    this.initialIndex = 0,
    this.initialBookshelfTabIntent,
  });

  final int initialIndex;
  final String? initialBookshelfTabIntent;

  @override
  State<MainTabShellPage> createState() => _MainTabShellPageState();
}

class _MainTabShellPageState extends State<MainTabShellPage> {
  final _mainTabController = MainTabController();

  @override
  void initState() {
    super.initState();
    final intent = widget.initialBookshelfTabIntent;
    if (intent != null && intent.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mainTabController.openBookshelfTab(intent);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BookstoreCubit()..load()),
        BlocProvider(create: (_) => WelfareCubit()..load()),
        BlocProvider(create: (_) => PartnerCubit()..load()),
        BlocProvider(create: (_) => BookshelfCubit()..load()),
        BlocProvider(create: (_) => ProfileCubit()..load()),
      ],
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
                  create: (_) =>
                      RankingCubit(initialDimension: RankingDimension.recommend)
                        ..load(),
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
    );
  }
}
