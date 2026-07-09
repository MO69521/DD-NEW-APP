import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/membership_status_service.dart';
import '../../../core/services/service_locator.dart';
import '../../../routes/app_router.dart';
import '../../../routes/app_routes.dart';
import '../data/datasources/account_settings_mock_datasource.dart';
import '../data/repositories/account_settings_repository_impl.dart';
import '../domain/entities/account_security_binding.dart';
import '../domain/repositories/account_settings_repository.dart';
import 'account_settings_state.dart';
import 'account_settings_ui_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  AccountSettingsCubit({
    AccountSettingsRepository? repository,
    MembershipStatusService? membership,
  }) : _repository =
           repository ??
           const AccountSettingsRepositoryImpl(
             AccountSettingsMockDataSource(),
           ),
       _membership = membership ?? ServiceLocator.membershipStatus,
       super(const AccountSettingsState()) {
    _membership.account.addListener(_onAccountChanged);
  }

  final AccountSettingsRepository _repository;
  final MembershipStatusService _membership;

  Future<void> load() async {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(isLoading: true, clearError: true),
      ),
    );

    try {
      final content = await _repository.fetchPageContent();
      final merged = content.copyWith(
        nickname: _membership.account.value.nickname,
      );
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: AccountSettingsDomainState(content: merged),
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

  void _onAccountChanged() {
    final content = state.domain.content;
    if (content == null) return;
    final nickname = _membership.account.value.nickname;
    if (content.nickname == nickname) return;
    emit(
      state.copyWith(
        domain: state.domain.copyWith(
          content: content.copyWith(nickname: nickname),
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _membership.account.removeListener(_onAccountChanged);
    return super.close();
  }

  void onAvatarTap() {
    AppRouter.pushNamed(AppRoutes.dressUpName);
  }

  void onNicknameTap() {
    AppRouter.pushNamed(
      AppRoutes.editNicknameName,
      extra: state.domain.content?.nickname ?? '',
    );
  }

  void onSecurityBindingTap(AccountSecurityBindingType type) {
    _emitActionMessage('${_bindingActionLabel(type)}功能即将上线');
  }

  void consumeActionMessage() {
    if (state.ui.actionMessage == null) return;
    emit(state.copyWith(ui: state.ui.copyWith(clearActionMessage: true)));
  }

  void _emitActionMessage(String message) {
    emit(state.copyWith(ui: state.ui.copyWith(actionMessage: message)));
  }

  String _bindingActionLabel(AccountSecurityBindingType type) {
    return switch (type) {
      AccountSecurityBindingType.phone => '换绑手机号',
      AccountSecurityBindingType.qq => '绑定 QQ',
      AccountSecurityBindingType.wechat => '绑定微信',
      AccountSecurityBindingType.douyin => '绑定抖音',
    };
  }
}
