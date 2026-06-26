import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/membership_status_service.dart';
import '../../../core/services/service_locator.dart';
import '../data/repositories/membership_repository_impl.dart';
import '../domain/repositories/membership_repository.dart';
import 'membership_domain_state.dart';
import 'membership_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class MembershipCubit extends Cubit<MembershipState> {
  MembershipCubit({MembershipRepository? repository})
    : _repository =
          repository ?? MembershipRepositoryImpl(_defaultStatusService()),
      super(const MembershipState());

  final MembershipRepository _repository;

  static MembershipStatusService _defaultStatusService() =>
      ServiceLocator.membershipStatus;

  Future<void> load() async {
    emit(
      state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)),
    );

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: MembershipDomainState(content: content),
          interaction: state.interaction.copyWith(
            selectedPlanId: content.defaultPlanId,
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          ),
        ),
      );
    }
  }

  void selectPlan(String planId) {
    if (state.interaction.selectedPlanId == planId) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedPlanId: planId),
      ),
    );
  }

  Future<void> purchase() async {
    final planId = state.interaction.selectedPlanId;
    if (planId == null || state.interaction.isPurchasing) return;

    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(isPurchasing: true),
      ),
    );

    try {
      await _repository.purchase(planId);
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          domain: MembershipDomainState(content: content),
          interaction: state.interaction.copyWith(
            isPurchasing: false,
            purchaseMessage: '开通成功，VIP特权已生效',
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          interaction: state.interaction.copyWith(
            isPurchasing: false,
            purchaseMessage: '开通失败，请稍后再试',
          ),
        ),
      );
    }
  }

  /// 提示消费后清空，避免重复弹出。
  void consumePurchaseMessage() {
    if (state.interaction.purchaseMessage == null) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(clearMessage: true),
      ),
    );
  }

  /// 打开协议（mock：暂不跳转外链）。
  void openAgreement(String url) {}
}
