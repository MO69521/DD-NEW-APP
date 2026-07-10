import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/currency_config.dart';
import '../../../../core/domain/entities/commerce_entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/components/recharge_packages_section.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../application/currency_wallet_cubit.dart';
import '../../application/currency_wallet_state.dart';
import '../../application/currency_wallet_ui_state.dart';
import '../../domain/entities/currency_wallet_page_content.dart';
import '../components/currency_balance_summary_card.dart';
import '../components/currency_ledger_section.dart';
import '../components/currency_info_dialog.dart';
import '../components/currency_obtain_ways_section.dart';
import '../components/currency_payment_section.dart';
import '../components/stardust_exchange_section.dart';

class CurrencyWalletPage extends StatelessWidget {
  const CurrencyWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrencyWalletCubit, CurrencyWalletState>(
      listenWhen: (previous, current) =>
          previous.ui.feedbackMessage != current.ui.feedbackMessage,
      listener: (context, state) {
        final feedback = state.ui.feedbackMessage;
        if (feedback == null || feedback.isEmpty) return;
        AppToast.show(context, feedback);
        context.read<CurrencyWalletCubit>().clearFeedback();
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final content = state.domain.content;
        final title = content == null
            ? '资产详情'
            : CurrencyConfig.label(content.type);
        final statusBarHeight = AppLayout.statusBarHeight(context);

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: AppPageChrome(
            topBar: AppTopBar(
              statusBarHeight: statusBarHeight,
              title: title,
              onBack: AppRouter.pop,
              actions: content == null
                  ? const []
                  : [
                      if (content.type == CurrencyType.energy)
                        AppTopBarAction(
                          label: '明细',
                          onTap: context
                              .read<CurrencyWalletCubit>()
                              .onEnergyRecordsTap,
                        )
                      else
                        AppTopBarAction(
                          iconAsset: 'assets/icons/welfare/recharge_info.svg',
                          onTap: () => CurrencyInfoDialog.show(
                            context,
                            title: CurrencyConfig.label(content.type),
                            sections: content.infoSections,
                          ),
                        ),
                    ],
            ),
            body: _CurrencyWalletBody(state: state),
          ),
          bottomNavigationBar: content == null
              ? null
              : _CurrencyWalletBottomBar(
                  content: content,
                  state: state,
                  onAction: context.read<CurrencyWalletCubit>().performAction,
                ),
        );
      },
    );
  }
}

class _CurrencyWalletBody extends StatelessWidget {
  const _CurrencyWalletBody({required this.state});

  final CurrencyWalletState state;

  @override
  Widget build(BuildContext context) {
    if (state.ui.phase == CurrencyWalletPhase.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.ui.errorMessage != null) {
      return EmptyState(
        title: '加载失败',
        description: state.ui.errorMessage,
        action: AppButton(
          label: '重试',
          onPressed: () => context.read<CurrencyWalletCubit>().load(),
        ),
      );
    }

    final content = state.domain.content;
    if (content == null) {
      return const EmptyState(title: '暂无数据');
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppLayout.chromeTopHeight(context) + AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.xxl,
      ),
      children: [
        CurrencyBalanceSummaryCard(
          type: content.type,
          balance: content.balance,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (content.type == CurrencyType.energy) ...[
          RechargePackagesSection(
            packages: content.rechargePackages,
            selectedPackageId: state.interaction.selectedEnergyOptionId,
            onPackageTap: (package) => context
                .read<CurrencyWalletCubit>()
                .selectEnergyOption(package.id),
          ),
          const SizedBox(height: AppSpacing.sm),
          CurrencyPaymentSection(
            selectedMethod: state.interaction.selectedPaymentMethod,
            onMethodTap: context
                .read<CurrencyWalletCubit>()
                .selectPaymentMethod,
          ),
        ] else if (content.type == CurrencyType.stardust) ...[
          StardustExchangeSection(
            options: content.stardustOptions,
            selectedOptionId: state.interaction.selectedStardustOptionId,
            onOptionTap: context
                .read<CurrencyWalletCubit>()
                .selectStardustOption,
          ),
          const SizedBox(height: AppSpacing.sm),
          CurrencyLedgerSection(
            type: content.type,
            records: content.ledgerRecords,
          ),
        ] else ...[
          CurrencyObtainWaysSection(
            ways: content.obtainWays,
            onAction: context.read<CurrencyWalletCubit>().performAction,
          ),
          const SizedBox(height: AppSpacing.sm),
          CurrencyLedgerSection(
            type: content.type,
            records: content.ledgerRecords,
          ),
        ],
      ],
    );
  }
}

class _CurrencyWalletBottomBar extends StatelessWidget {
  const _CurrencyWalletBottomBar({
    required this.content,
    required this.state,
    required this.onAction,
  });

  final CurrencyWalletPageContent content;
  final CurrencyWalletState state;
  final ValueChanged<CurrencyWalletAction> onAction;

  @override
  Widget build(BuildContext context) {
    final secondaryActionLabel = content.secondaryActionLabel;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        color: AppColors.backgroundDark,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              label: _primaryLabel,
              variant: AppButtonVariant.accent,
              isExpanded: true,
              onPressed: () => onAction(_primaryAction),
            ),
            if (secondaryActionLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: secondaryActionLabel,
                variant: AppButtonVariant.secondary,
                isExpanded: true,
                onPressed: () => onAction(CurrencyWalletAction.welfare),
              ),
            ],
          ],
        ),
      ),
    );
  }

  CurrencyWalletAction get _primaryAction {
    return switch (content.type) {
      CurrencyType.energy => CurrencyWalletAction.recharge,
      CurrencyType.wishStar => CurrencyWalletAction.wish,
      CurrencyType.love => CurrencyWalletAction.confess,
      CurrencyType.stardust => CurrencyWalletAction.exchange,
    };
  }

  String get _primaryLabel {
    if (content.type == CurrencyType.energy) {
      final selected = content.rechargePackages.where(
        (item) => item.id == state.interaction.selectedEnergyOptionId,
      );
      final option = selected.isEmpty ? null : selected.first;
      final price = option?.priceYuan ?? 0;
      return '${state.interaction.selectedPaymentMethod.label} ¥$price';
    }
    return content.primaryActionLabel ?? CurrencyConfig.label(content.type);
  }
}
