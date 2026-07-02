import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/currency_config.dart';
import '../../../core/domain/entities/commerce_entities.dart';
import '../../../routes/app_router.dart';
import '../../../routes/app_routes.dart';
import '../data/datasources/welfare_mock_datasource.dart';
import '../data/repositories/welfare_repository_impl.dart';
import '../domain/repositories/welfare_repository.dart';
import 'welfare_domain_state.dart';
import 'welfare_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class WelfareCubit extends Cubit<WelfareState> {
  WelfareCubit({WelfareRepository? repository})
    : _repository =
          repository ?? const WelfareRepositoryImpl(WelfareMockDataSource()),
      super(const WelfareState());

  final WelfareRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(ui: state.ui.copyWith(isLoading: true, clearError: true)),
    );

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: WelfareDomainState(content: content),
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

  void onCurrencyTap(CurrencyType type) {
    AppRouter.pushNamed(
      AppRoutes.currencyWalletName,
      pathParameters: {'type': CurrencyConfig.slug(type)},
    );
  }
}
