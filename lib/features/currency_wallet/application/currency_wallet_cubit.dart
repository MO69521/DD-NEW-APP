import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/main_tab_config.dart';
import '../../../core/domain/entities/commerce_entities.dart';
import '../../../routes/app_router.dart';
import '../../../routes/app_routes.dart';
import '../data/datasources/currency_wallet_mock_datasource.dart';
import '../data/repositories/currency_wallet_repository_impl.dart';
import '../domain/entities/currency_wallet_page_content.dart';
import '../domain/repositories/currency_wallet_repository.dart';
import 'currency_wallet_domain_state.dart';
import 'currency_wallet_interaction_state.dart';
import 'currency_wallet_state.dart';
import 'currency_wallet_ui_state.dart';

class CurrencyWalletCubit extends Cubit<CurrencyWalletState> {
  CurrencyWalletCubit(this._type, {CurrencyWalletRepository? repository})
    : _repository =
          repository ??
          const CurrencyWalletRepositoryImpl(CurrencyWalletMockDataSource()),
      super(const CurrencyWalletState());

  final CurrencyType _type;
  final CurrencyWalletRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          phase: CurrencyWalletPhase.loading,
          clearError: true,
          clearFeedback: true,
        ),
      ),
    );

    try {
      final content = await _repository.fetchPageContent(_type);
      emit(
        state.copyWith(
          ui: state.ui.copyWith(phase: CurrencyWalletPhase.loaded),
          domain: CurrencyWalletDomainState(content: content),
          interaction: _initialInteraction(content),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            phase: CurrencyWalletPhase.empty,
            errorMessage: error.toString(),
          ),
        ),
      );
    }
  }

  void selectEnergyOption(String id) {
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedEnergyOptionId: id),
      ),
    );
  }

  void selectPaymentMethod(PaymentMethod method) {
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedPaymentMethod: method),
      ),
    );
  }

  void selectStardustOption(String id) {
    final content = state.domain.content;
    final option = _firstWhereOrNull(
      content?.stardustOptions ?? const [],
      (item) => item.id == id,
    );
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedStardustOptionId: id),
        domain: content == null || option == null
            ? state.domain
            : state.domain.copyWith(
                content: CurrencyWalletPageContent(
                  type: content.type,
                  balance: content.balance,
                  obtainWays: content.obtainWays,
                  ledgerRecords: content.ledgerRecords,
                  rechargePackages: content.rechargePackages,
                  stardustOptions: content.stardustOptions,
                  ruleDescriptions: content.ruleDescriptions,
                  primaryActionLabel: '兑换${option.energyAmount}能量',
                  secondaryActionLabel: content.secondaryActionLabel,
                ),
              ),
      ),
    );
  }

  void performAction(CurrencyWalletAction action) {
    if (action == CurrencyWalletAction.welfare) {
      AppRouter.goMainTab(MainTabConfig.welfareIndex);
      return;
    }
    emit(
      state.copyWith(
        ui: state.ui.copyWith(feedbackMessage: _feedbackForAction(action)),
      ),
    );
  }

  void clearFeedback() {
    emit(state.copyWith(ui: state.ui.copyWith(clearFeedback: true)));
  }

  void onEnergyRecordsTap() {
    AppRouter.pushNamed(AppRoutes.energyRecordsName);
  }

  CurrencyWalletInteractionState _initialInteraction(
    CurrencyWalletPageContent content,
  ) {
    return CurrencyWalletInteractionState(
      selectedEnergyOptionId:
          _firstOrNull(content.rechargePackages)?.id ??
          const CurrencyWalletInteractionState().selectedEnergyOptionId,
      selectedStardustOptionId:
          _firstOrNull(content.stardustOptions)?.id ??
          const CurrencyWalletInteractionState().selectedStardustOptionId,
    );
  }

  String _feedbackForAction(CurrencyWalletAction action) {
    final content = state.domain.content;
    final interaction = state.interaction;
    final energyOption = _firstWhereOrNull(
      content?.rechargePackages ?? const [],
      (item) => item.id == interaction.selectedEnergyOptionId,
    );
    final stardustOption = _firstWhereOrNull(
      content?.stardustOptions ?? const [],
      (item) => item.id == interaction.selectedStardustOptionId,
    );
    final paymentLabel = interaction.selectedPaymentMethod.label;

    return switch (action) {
      CurrencyWalletAction.recharge =>
        energyOption == null
            ? '请选择能量套餐'
            : '$paymentLabel ¥${energyOption.priceYuan} 已模拟提交',
      CurrencyWalletAction.exchange =>
        stardustOption == null
            ? '请选择兑换档位'
            : content != null && content.balance < stardustOption.stardustCost
            ? '星尘不足，去福利页赚更多吧'
            : '已模拟兑换 ${stardustOption.energyAmount} 能量',
      CurrencyWalletAction.wish => '祈愿入口待接入，已保留跳转动作',
      CurrencyWalletAction.viewShop => '商店入口待接入，已保留跳转动作',
      CurrencyWalletAction.viewGift => '爱心礼包入口待接入，已保留跳转动作',
      CurrencyWalletAction.confess => '表白入口待接入，已保留跳转动作',
      CurrencyWalletAction.welfare => '福利页入口待接入，已保留跳转动作',
      CurrencyWalletAction.detail => '明细页待接入，当前展示最近记录',
      CurrencyWalletAction.info => '规则说明已在页面下方展示',
    };
  }

  T? _firstOrNull<T>(List<T> items) {
    return items.isEmpty ? null : items.first;
  }

  T? _firstWhereOrNull<T>(List<T> items, bool Function(T item) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }
}
