import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/main_tab_config.dart';
import '../../../../core/constants/bookshelf_tab_intent.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/currency_balance_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/components/energy_recharge_purchase_dialog.dart';
import '../../../../shared/components/recharge_packages_section.dart';
import '../../../../shared/components/vip_promo_banner.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../shared/layouts/main_tab_controller.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/profile_cubit.dart';
import '../../application/profile_state.dart';
import '../../domain/entities/profile_page_content.dart';
import '../components/profile_hero_header.dart';
import '../components/profile_shortcut_grid.dart';
import '../../domain/entities/profile_menu_item.dart';

/// 我的页（Figma 697:12323）：仅渲染 state、触发 action。
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.mainTabController});

  final MainTabController? mainTabController;

  static const double _bottomNavReserve =
      AppBottomNav.barHeight + AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
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
                onPressed: () => context.read<ProfileCubit>().load(),
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

        return _ProfileView(
          content: content,
          mainTabController: mainTabController,
        );
      },
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.content, this.mainTabController});

  final ProfilePageContent content;
  final MainTabController? mainTabController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final heroBackgroundHeight = AppLayout.figmaFrameHeight(
      context,
      AppSizes.profileHeroHeight,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: heroBackgroundHeight,
                          child: ProfileHeroBackground(
                            avatarUrl: content.user.avatarUrl,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ProfileHeroHeader(
                              user: content.user,
                              onProfileTap: cubit.onProfileTap,
                              onPartnersTap: cubit.onPartnersTap,
                              showBackground: false,
                              showMessagesButton: false,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                              ),
                              child: Transform.translate(
                                offset: const Offset(
                                  0,
                                  -AppSizes.profileBalanceBarHeroOverlap,
                                ),
                                child: CurrencyBalanceBar(
                                  balances: content.currencyBalances,
                                  onCurrencyTap: cubit.onCurrencyTap,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(
                        0,
                        -AppSizes.profileBalanceBarHeroOverlap,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.insetMd,
                          AppSizes.profileBalanceBarToVipGap,
                          AppSpacing.insetMd,
                          ProfilePage._bottomNavReserve,
                        ),
                        child: Column(
                          children: [
                            if (!content.user.isVip)
                              VipPromoBanner(
                                monthlyEnergy: content.vipMonthlyEnergy,
                                priceYuan: content.vipPriceYuan,
                                onTap: () {
                                  cubit.onVipPromoTap();
                                  AppRouter.pushNamed(AppRoutes.membershipName);
                                },
                              ),
                            if (!content.user.isVip)
                              const SizedBox(height: AppSpacing.sm),
                            RechargePackagesSection(
                              packages: content.rechargePackages,
                              onPackageTap: (package) =>
                                  EnergyRechargePurchaseDialog.show(
                                context,
                                package: package,
                              ),
                              onMoreTap: () => mainTabController?.switchTo(
                                MainTabConfig.welfareIndex,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ProfileShortcutGrid(
                              items: content.menuItems,
                              onItemTap: (action) {
                                if (action ==
                                    ProfileMenuAction.readingHistory) {
                                  mainTabController?.openBookshelfTab(
                                    BookshelfTabIntent.history,
                                  );
                                  return;
                                }
                                cubit.onMenuTap(action);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: AppLayout.figmaFrameTop(
              context,
              AppSizes.profileHeroSettingsTop,
            ),
            right: AppSpacing.md,
            child: ProfileMessagesButton(onTap: cubit.onMessagesTap),
          ),
        ],
      ),
    );
  }
}
