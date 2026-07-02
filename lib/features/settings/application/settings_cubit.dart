import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../routes/app_router.dart';
import '../../../routes/app_routes.dart';
import '../data/datasources/settings_mock_datasource.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/entities/settings_menu_item.dart';
import '../domain/repositories/settings_repository.dart';
import 'settings_state.dart';
import 'settings_ui_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({SettingsRepository? repository})
    : _repository =
          repository ?? const SettingsRepositoryImpl(SettingsMockDataSource()),
      super(const SettingsState());

  final SettingsRepository _repository;

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
          domain: SettingsDomainState(content: content),
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

  void onMenuItemTap(SettingsMenuAction action) {
    switch (action) {
      case SettingsMenuAction.accountSettings:
        AppRouter.pushNamed(AppRoutes.accountSettingsName);
      case SettingsMenuAction.notifications:
      case SettingsMenuAction.personalizedAds:
      case SettingsMenuAction.readingPreferences:
      case SettingsMenuAction.teenMode:
      case SettingsMenuAction.userAgreement:
      case SettingsMenuAction.privacyPolicy:
      case SettingsMenuAction.thirdPartySharing:
      case SettingsMenuAction.versionUpdate:
        _emitActionMessage('${_actionLabel(action)}功能即将上线');
    }
  }

  void onLogoutTap() {
    _emitActionMessage('退出登录功能即将上线');
  }

  void onDeleteAccountTap() {
    _emitActionMessage('注销账号功能即将上线');
  }

  void consumeActionMessage() {
    if (state.ui.actionMessage == null) return;
    emit(state.copyWith(ui: state.ui.copyWith(clearActionMessage: true)));
  }

  void _emitActionMessage(String message) {
    emit(state.copyWith(ui: state.ui.copyWith(actionMessage: message)));
  }

  String _actionLabel(SettingsMenuAction action) {
    return switch (action) {
      SettingsMenuAction.notifications => '消息通知',
      SettingsMenuAction.accountSettings => '账号设置',
      SettingsMenuAction.personalizedAds => '个性化广告',
      SettingsMenuAction.readingPreferences => '阅读偏好',
      SettingsMenuAction.teenMode => '青少年模式',
      SettingsMenuAction.userAgreement => '用户协议',
      SettingsMenuAction.privacyPolicy => '隐私政策',
      SettingsMenuAction.thirdPartySharing => '第三方服务共享清单',
      SettingsMenuAction.versionUpdate => '版本更新',
    };
  }
}
