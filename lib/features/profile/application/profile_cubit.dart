import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/profile_mock_datasource.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/entities/profile_menu_item.dart';
import '../domain/repositories/profile_repository.dart';
import 'profile_state.dart';
import 'profile_ui_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({ProfileRepository? repository})
    : _repository = repository ??
          const ProfileRepositoryImpl(ProfileMockDataSource()),
      super(const ProfileState());

  final ProfileRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)));

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

  void onSettingsTap() {}

  void onPartnersTap() {}

  void onVipPromoTap() {}

  void onMenuTap(ProfileMenuAction action) {}
}
