import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/layouts/app_scroll_blur_scope.dart';
import '../../application/membership_cubit.dart';
import '../../application/membership_state.dart';
import '../../domain/entities/membership_page_content.dart';
import '../../domain/entities/membership_plan.dart';
import '../components/membership_app_bar.dart';
import '../components/membership_auto_renew_statement.dart';
import '../components/membership_benefits_section.dart';
import '../components/membership_hero.dart';
import '../components/membership_plan_selector.dart';
import '../components/membership_purchase_bar.dart';
import '../components/membership_renew_hint.dart';
import '../components/membership_user_card.dart';

/// L3 页面 — VIP 会员（Figma 927:725）：仅渲染 state、触发 action。
class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MembershipCubit, MembershipState>(
      listenWhen: (previous, current) =>
          previous.interaction.purchaseMessage !=
          current.interaction.purchaseMessage,
      listener: (context, state) {
        final message = state.interaction.purchaseMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
        context.read<MembershipCubit>().consumePurchaseMessage();
      },
      builder: (context, state) {
        if (state.ui.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(child: CircularProgressIndicator()),
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
                onPressed: () => context.read<MembershipCubit>().load(),
              ),
            ),
          );
        }

        final content = state.domain.content;
        if (content == null) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: EmptyState(title: '暂无数据'),
          );
        }

        return _MembershipView(
          content: content,
          selectedPlanId: state.interaction.selectedPlanId,
          isPurchasing: state.interaction.isPurchasing,
        );
      },
    );
  }
}

class _MembershipView extends StatelessWidget {
  const _MembershipView({
    required this.content,
    required this.selectedPlanId,
    required this.isPurchasing,
  });

  final MembershipPageContent content;
  final String? selectedPlanId;
  final bool isPurchasing;

  MembershipPlan get _selectedPlan => content.plans.firstWhere(
    (p) => p.id == selectedPlanId,
    orElse: () => content.plans.first,
  );

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MembershipCubit>();
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final renewHint = _selectedPlan.renewHint;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppScrollBlurScope(
        builder: (context, topBlurEnabled) => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: AppSizes.membershipHeroLayoutHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: AppSizes.membershipHeroHeight,
                          child: MembershipHero(slides: content.heroSlides),
                        ),
                        Positioned(
                          left: AppSpacing.sm,
                          right: AppSpacing.sm,
                          top: AppSizes.membershipUserCardTop,
                          child: MembershipUserCard(account: content.account),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: AppSizes.membershipHeroToPlanGap,
                        ),
                        MembershipPlanSelector(
                          plans: content.plans,
                          selectedPlanId: selectedPlanId,
                          onSelect: cubit.selectPlan,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        MembershipRenewHintSlot(hint: renewHint),
                        MembershipPurchaseBar(
                          priceText: _selectedPlan.priceText,
                          agreementPrefix: content.agreementPrefix,
                          agreementSuffix: content.agreementSuffix,
                          agreements: content.agreements,
                          isPurchasing: isPurchasing,
                          onPurchase: cubit.purchase,
                          onAgreementTap: (agreement) =>
                              cubit.openAgreement(agreement.url),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        MembershipBenefitsSection(benefits: content.benefits),
                        const SizedBox(height: AppSpacing.sm),
                        MembershipAutoRenewStatement(
                          title: content.statementTitle,
                          paragraphs: content.statementParagraphs,
                        ),
                        SizedBox(height: AppSpacing.xl + bottomInset),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBlurredChromeBar(
                enabled: topBlurEnabled,
                child: MembershipAppBar(
                  statusBarHeight: statusBarHeight,
                  onBack: AppRouter.pop,
                  onRecordsTap: () =>
                      AppRouter.pushNamed(AppRoutes.rechargeRecordsName),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
