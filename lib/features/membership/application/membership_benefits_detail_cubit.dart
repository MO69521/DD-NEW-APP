import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/membership_status_service.dart';
import '../../../core/services/service_locator.dart';
import '../data/repositories/membership_repository_impl.dart';
import '../domain/repositories/membership_repository.dart';
import 'membership_benefits_detail_state.dart';

/// 会员特权详情页 application 层，state 仅在此层创建与修改。
class MembershipBenefitsDetailCubit
    extends Cubit<MembershipBenefitsDetailState> {
  MembershipBenefitsDetailCubit({MembershipRepository? repository})
    : _repository =
          repository ?? MembershipRepositoryImpl(_defaultStatusService()),
      super(const MembershipBenefitsDetailState());

  final MembershipRepository _repository;

  static MembershipStatusService _defaultStatusService() =>
      ServiceLocator.membershipStatus;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final benefits = await _repository.fetchBenefitDetails();
    emit(state.copyWith(benefits: benefits, isLoading: false));
  }
}
