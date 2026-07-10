import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/currency_config.dart';
import '../../../core/domain/entities/commerce_entities.dart';
import '../../../routes/app_router.dart';
import '../../../routes/app_routes.dart';
import '../data/datasources/welfare_mock_datasource.dart';
import '../data/repositories/welfare_repository_impl.dart';
import '../domain/entities/welfare_models.dart';
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

  /// 每日签到聚合数据（未加载时为 null）；供首页首启签到弹窗复用。
  CheckInSummary? get checkInSummary => state.domain.content?.checkInSummary;

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

  /// 每日签到：标记今日已签到（一天仅可签到一次，签到后按钮切换为看视频）。
  void checkIn() {
    if (state.ui.hasCheckedInToday) return;
    emit(state.copyWith(ui: state.ui.copyWith(hasCheckedInToday: true)));
  }

  void onCurrencyTap(CurrencyType type) {
    AppRouter.pushNamed(
      AppRoutes.currencyWalletName,
      pathParameters: {'type': CurrencyConfig.slug(type)},
    );
  }
}
