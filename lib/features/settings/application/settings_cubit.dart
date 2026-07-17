import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/service_locator.dart';
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
          repository ??
          SettingsRepositoryImpl(
            SettingsMockDataSource(ServiceLocator.teenMode),
          ),
      super(const SettingsState());

  static const String _mockLatestVersion = '3.9.6.7';

  final SettingsRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)),
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
        AppRouter.pushNamed(AppRoutes.notificationSettingsName);
      case SettingsMenuAction.personalizedAds:
        AppRouter.pushNamed(AppRoutes.personalizedAdsName);
      case SettingsMenuAction.readingPreferences:
        AppRouter.pushNamed(AppRoutes.readingPreferencesName);
      case SettingsMenuAction.teenMode:
        AppRouter.pushNamed(AppRoutes.teenModeName);
      case SettingsMenuAction.userAgreement:
        AppRouter.pushNamed(
          AppRoutes.settingsDocumentName,
          pathParameters: {'type': 'user-agreement'},
        );
      case SettingsMenuAction.privacyPolicy:
        AppRouter.pushNamed(
          AppRoutes.settingsDocumentName,
          pathParameters: {'type': 'privacy-policy'},
        );
      case SettingsMenuAction.thirdPartySharing:
        AppRouter.pushNamed(
          AppRoutes.settingsDocumentName,
          pathParameters: {'type': 'third-party-sharing'},
        );
      case SettingsMenuAction.versionUpdate:
        _checkVersionUpdate();
    }
  }

  Future<void> onLogoutTap() async {
    if (state.ui.isLoggingOut) return;

    emit(
      state.copyWith(
        ui: state.ui.copyWith(isLoggingOut: true, clearActionMessage: true),
      ),
    );

    try {
      await ServiceLocator.authService.logout();
    } catch (_) {
      // 登出以清理本地会话为准，接口失败不阻塞回到登录页。
    }

    await ServiceLocator.authSession.clear();
    if (isClosed) return;
    emit(state.copyWith(ui: state.ui.copyWith(isLoggingOut: false)));
    AppRouter.go(AppRoutes.login);
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

  Future<void> _checkVersionUpdate() async {
    final currentVersion = state.domain.content?.appVersion;
    final isLatest = await _isLatestVersion(currentVersion);
    if (isLatest) {
      _emitActionMessage('已是最新版本');
      return;
    }

    _emitActionMessage('发现新版本');
  }

  Future<bool> _isLatestVersion(String? currentVersion) async {
    // Phase 1 使用 mock 版本号，后续接入应用商店/API 后替换这里的来源。
    return currentVersion == _mockLatestVersion;
  }
}
