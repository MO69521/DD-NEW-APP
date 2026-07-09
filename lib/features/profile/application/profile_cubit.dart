import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/currency_config.dart';
import '../../../core/domain/entities/commerce_entities.dart';
import '../../../core/services/membership_status_service.dart';
import '../../../core/services/service_locator.dart';
import '../../../routes/app_router.dart';
import '../../../routes/app_routes.dart';
import '../data/datasources/profile_mock_datasource.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/entities/profile_menu_item.dart';
import '../domain/repositories/profile_repository.dart';
import 'profile_state.dart';
import 'profile_ui_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    ProfileRepository? repository,
    MembershipStatusService? membership,
  }) : _repository =
           repository ?? const ProfileRepositoryImpl(ProfileMockDataSource()),
       _membership = membership ?? ServiceLocator.membershipStatus,
       super(const ProfileState()) {
    _membership.account.addListener(_onAccountChanged);
  }

  final ProfileRepository _repository;
  final MembershipStatusService _membership;

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
      final merged = content.copyWith(
        user: content.user.copyWith(
          nickname: _membership.account.value.nickname,
        ),
      );
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: ProfileDomainState(content: merged),
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
    if (content.user.nickname == nickname) return;
    emit(
      state.copyWith(
        domain: state.domain.copyWith(
          content: content.copyWith(
            user: content.user.copyWith(nickname: nickname),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _membership.account.removeListener(_onAccountChanged);
    return super.close();
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
        AppRouter.pushNamed(AppRoutes.cardPackName);
      case ProfileMenuAction.dressUp:
        AppRouter.pushNamed(AppRoutes.dressUpName);
      case ProfileMenuAction.cardAlbum:
        break;
    }
  }

  Future<void> _openQqGroup() async {
    if (!await canLaunchUrl(_qqGroupUri)) return;
    await launchUrl(_qqGroupUri, mode: LaunchMode.externalApplication);
  }
}
