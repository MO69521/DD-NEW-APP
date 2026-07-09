import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/user_basic_info.dart';

/// 收集步骤：先选性别，再横向切到选年龄。
enum OnboardingStep { gender, age }

class OnboardingState extends Equatable {
  const OnboardingState({
    this.gender,
    this.ageRange,
    this.step = OnboardingStep.gender,
  });

  final UserGender? gender;
  final UserAgeRange? ageRange;
  final OnboardingStep step;

  bool get canSubmit => gender != null && ageRange != null;

  OnboardingState copyWith({
    UserGender? gender,
    UserAgeRange? ageRange,
    OnboardingStep? step,
  }) {
    return OnboardingState(
      gender: gender ?? this.gender,
      ageRange: ageRange ?? this.ageRange,
      step: step ?? this.step,
    );
  }

  @override
  List<Object?> get props => [gender, ageRange, step];
}
