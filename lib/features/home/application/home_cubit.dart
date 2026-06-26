import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/home_local_datasource.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import 'home_domain_state.dart';
import 'home_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HomeRepository? repository})
      : _repository = repository ??
            const HomeRepositoryImpl(HomeLocalDataSource()),
        super(const HomeState());

  final HomeRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)));

    try {
      final info = await _repository.getHomeInfo();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: HomeDomainState(info: info),
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
}
