import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/account_settings_mock_datasource.dart';
import '../data/repositories/account_settings_repository_impl.dart';
import '../domain/entities/account_security_binding.dart';
import '../domain/repositories/account_settings_repository.dart';
import 'account_settings_state.dart';
import 'account_settings_ui_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  AccountSettingsCubit({AccountSettingsRepository? repository})
    : _repository =
          repository ??
          const AccountSettingsRepositoryImpl(AccountSettingsMockDataSource()),
      super(const AccountSettingsState());

  final AccountSettingsRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(isLoading: true, clearError: true),
      ),
    );

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: AccountSettingsDomainState(content: content),
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

  void onAvatarTap() {
    _emitActionMessage('修改头像功能即将上线');
  }

  void onNicknameTap() {
    _emitActionMessage('修改昵称功能即将上线');
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
