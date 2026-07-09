import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/user_basic_info.dart';
import '../../../core/services/onboarding_service.dart';
import '../../../core/services/service_locator.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({OnboardingService? service})
    : _service = service ?? ServiceLocator.onboarding,
      super(const OnboardingState());

  final OnboardingService _service;

  /// 选择性别后自动进入「选择年龄」步骤（横向切换）。
  void selectGender(UserGender gender) {
    emit(state.copyWith(gender: gender, step: OnboardingStep.age));
  }

  void selectAgeRange(UserAgeRange ageRange) {
    emit(state.copyWith(ageRange: ageRange));
  }

  /// 切换收集步骤（分页器点击 / 跟手滑动统一入口）。
  void setStep(OnboardingStep step) {
    if (state.step == step) return;
    emit(state.copyWith(step: step));
  }

  /// 提交并标记新手信息已收集；返回是否成功（未选全则忽略）。
  bool submit() {
    if (!state.canSubmit) return false;
    _service.completeBasicInfo(
      gender: state.gender!,
      ageRange: state.ageRange!,
    );
    return true;
  }
}
