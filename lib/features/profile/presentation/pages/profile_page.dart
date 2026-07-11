import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/main_tab_config.dart';
import '../../../../core/constants/bookshelf_tab_intent.dart';
import '../../../../core/domain/entities/commerce_entities.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_async_page_body.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/components/currency_balance_bar.dart';
import '../../../../shared/components/energy_recharge_purchase_dialog.dart';
import '../../../../shared/components/recharge_packages_section.dart';
import '../../../../shared/components/vip_promo_banner.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../shared/layouts/main_tab_controller.dart';
import '../../application/profile_cubit.dart';
import '../../application/profile_state.dart';
import '../../domain/entities/profile_page_content.dart';
import '../components/profile_achievement_section.dart';
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
        final content = state.domain.content;
        if (state.ui.isLoading ||
            state.ui.errorMessage != null ||
            content == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: AppAsyncPageBody(
              isLoading: state.ui.isLoading,
              errorMessage: state.ui.errorMessage,
              onRetry: () => context.read<ProfileCubit>().load(),
              isEmpty: content == null,
              child: const SizedBox.shrink(),
            ),
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
                            backgroundAsset: content.user.heroBackgroundAsset,
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
                          AppSpacing.md,
                          AppSizes.profileBalanceBarToVipGap,
                          AppSpacing.md,
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
                            ProfileAchievementSection(
                              earnedCount: content.achievementCount,
                              badges: content.achievementBadges,
                              onViewDetail: () =>
                                  AppToast.show(context, '成就详情即将上线'),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            RechargePackagesSection(
                              packages: content.rechargePackages,
                              freeClaimOptions: content.freeClaimOptions,
                              onPackageTap: (package) =>
                                  EnergyRechargePurchaseDialog.show(
                                context,
                                package: package,
                              ),
                              onFreeClaimTap: (option) {
                                if (option.kind == EnergyFreeClaimKind.vip) {
                                  AppRouter.pushNamed(
                                    AppRoutes.membershipName,
                                  );
                                } else {
                                  mainTabController?.switchTo(
                                    MainTabConfig.welfareIndex,
                                  );
                                }
                              },
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
