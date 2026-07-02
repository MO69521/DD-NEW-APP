import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/currency_config.dart';
import '../../../core/domain/entities/commerce_entities.dart';
import '../../../routes/app_router.dart';
import '../../../routes/app_routes.dart';
import '../data/datasources/profile_mock_datasource.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/entities/profile_menu_item.dart';
import '../domain/repositories/profile_repository.dart';
import 'profile_state.dart';
import 'profile_ui_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({ProfileRepository? repository})
    : _repository =
          repository ?? const ProfileRepositoryImpl(ProfileMockDataSource()),
      super(const ProfileState());

  final ProfileRepository _repository;

  static final Uri _qqGroupUri = Uri.parse(
    'mqqapi://card/show_pslcard'
    '?src_type=internal'
    '&version=1'
    '&uin=406584'
    '&card_type=group'
    '&source=qrcode',
  );

  Future<void> load() async {
    emit(
      state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)),
    );

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: ProfileDomainState(content: content),
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

  void onProfileTap() {
    AppRouter.pushNamed(AppRoutes.accountSettingsName);
  }

  void onMessagesTap() {
    AppRouter.pushNamed(AppRoutes.myMessagesName);
  }

  void onSettingsTap() {}

  void onPartnersTap() {}

  void onVipPromoTap() {}

  void onCurrencyTap(CurrencyType type) {
    AppRouter.pushNamed(
      AppRoutes.currencyWalletName,
      pathParameters: {'type': CurrencyConfig.slug(type)},
    );
  }

  void onMenuTap(ProfileMenuAction action) {
    switch (action) {
      case ProfileMenuAction.settings:
        AppRouter.pushNamed(AppRoutes.settingsName);
      case ProfileMenuAction.helpFeedback:
        AppRouter.pushNamed(AppRoutes.helpFeedbackName);
      case ProfileMenuAction.readingHistory:
        break;
      case ProfileMenuAction.qqGroup:
        unawaited(_openQqGroup());
      case ProfileMenuAction.cardPack:
      case ProfileMenuAction.dressUp:
      case ProfileMenuAction.cardAlbum:
        break;
    }
  }

  Future<void> _openQqGroup() async {
    if (!await canLaunchUrl(_qqGroupUri)) return;
    await launchUrl(_qqGroupUri, mode: LaunchMode.externalApplication);
  }
}
