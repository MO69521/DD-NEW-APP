import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/entities/user_basic_info.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/app_dialog_top_texture.dart';
import '../../../../shared/components/app_page_dots.dart';
import '../../../../shared/components/age_range_option.dart';
import '../../../../shared/components/app_swipe_tab_switcher.dart';
import '../../../../shared/components/dialog_close_button.dart';
import '../../../../shared/components/gender_avatar_option.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/onboarding_cubit.dart';
import '../../application/onboarding_state.dart';

/// L3 页面 — 新手基础信息收集弹窗（性别 / 年龄，深色主题）。
///
/// 不可点遮罩关闭；两步横向切换（选性别 → 选年龄），高度固定、
/// 底部分页器可回退，选全后「完成」按钮可用。
class OnboardingProfileDialog extends StatelessWidget {
  const OnboardingProfileDialog({super.key});

  /// 在首页之上弹出（必填，不可点遮罩关闭）。
  static Future<void> show(BuildContext context) {
    return showAppBlurredDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider(
        create: (_) => OnboardingCubit(),
        child: const OnboardingProfileDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.dialogBackground,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Stack(
                children: [
                  const AppDialogTopTexture(),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          '选择你的性别年龄',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textOnDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        AppText(
                          '让点点更了解你的喜好',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textOnDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // 两步横向切换：高度固定（取较高的年龄步），左右滑动。
                        const _StepSwitcher(),
                        const SizedBox(height: AppSpacing.lg),
                        BlocSelector<
                          OnboardingCubit,
                          OnboardingState,
                          OnboardingStep
                        >(
                          selector: (state) => state.step,
                          builder: (context, step) {
                            final cubit = context.read<OnboardingCubit>();
                            return AppPageDots(
                              count: 2,
                              current: step == OnboardingStep.gender ? 0 : 1,
                              onDotTap: (i) => cubit.setStep(
                                i == 0
                                    ? OnboardingStep.gender
                                    : OnboardingStep.age,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        BlocSelector<OnboardingCubit, OnboardingState, bool>(
                          selector: (state) => state.canSubmit,
                          builder: (context, canSubmit) {
                            return AppButton(
                              label: '完成',
                              variant: AppButtonVariant.accent,
                              isExpanded: true,
                              onPressed: canSubmit
                                  ? () {
                                      context.read<OnboardingCubit>().submit();
                                      Navigator.of(context).pop();
                                    }
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.lg,
            right: AppSpacing.lg,
            child: DialogCloseButton(onTap: () => Navigator.of(context).pop()),
          ),
        ],
      ),
    );
  }
}

/// 两步横向切换容器：固定视口高度 + 全局统一跟手滑动（[AppSwipeTabSwitcher]）。
class _StepSwitcher extends StatelessWidget {
  const _StepSwitcher();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final step = context.select<OnboardingCubit, OnboardingStep>(
      (c) => c.state.step,
    );

    return SizedBox(
      height: AppSizes.onboardingStepViewportHeight,
      child: AppSwipeTabSwitcher(
        selectedIndex: step == OnboardingStep.gender ? 0 : 1,
        onIndexChanged: (index) => cubit.setStep(
          index == 0 ? OnboardingStep.gender : OnboardingStep.age,
        ),
        children: const [
          Center(child: _GenderStep()),
          Center(child: _AgeStep()),
        ],
      ),
    );
  }
}

/// 步骤一：选择性别（选后自动横切到年龄）。
class _GenderStep extends StatelessWidget {
  const _GenderStep();

  @override
  Widget build(BuildContext context) {
    final gender = context.select<OnboardingCubit, UserGender?>(
      (c) => c.state.gender,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SectionLabel('选择性别'),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: GenderAvatarOption(
                label: UserGender.female.label,
                activeAsset:
                    'assets/images/onboarding/gender_female_active.png',
                inactiveAsset:
                    'assets/images/onboarding/gender_female_inactive.png',
                selected: gender == UserGender.female,
                onTap: () =>
                    _selectGenderWithPreview(context, UserGender.female),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GenderAvatarOption(
                label: UserGender.male.label,
                activeAsset: 'assets/images/onboarding/gender_male_active.png',
                inactiveAsset:
                    'assets/images/onboarding/gender_male_inactive.png',
                selected: gender == UserGender.male,
                onTap: () => _selectGenderWithPreview(context, UserGender.male),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectGenderWithPreview(
    BuildContext context,
    UserGender selectedGender,
  ) async {
    final cubit = context.read<OnboardingCubit>();
    cubit.selectGender(selectedGender);
    await Future<void>.delayed(AppDurations.slow);
    if (!context.mounted) return;
    if (cubit.state.gender == selectedGender &&
        cubit.state.step == OnboardingStep.gender) {
      cubit.setStep(OnboardingStep.age);
    }
  }
}

/// 步骤二：选择年龄。
class _AgeStep extends StatelessWidget {
  const _AgeStep();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final ageRange = context.select<OnboardingCubit, UserAgeRange?>(
      (c) => c.state.ageRange,
    );
    const values = UserAgeRange.values;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SectionLabel('选择年龄'),
        const SizedBox(height: AppSpacing.lg),
        for (var i = 0; i < values.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          AgeRangeOption(
            label: values[i].label,
            selected: ageRange == values[i],
            onTap: () => cubit.selectAgeRange(values[i]),
          ),
        ],
      ],
    );
  }
}

/// 分区标签：「— 文案 —」，两侧细短线。
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _LabelLine(),
        const SizedBox(width: AppSpacing.sm),
        AppText(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnDarkMuted,
          ),
          maxLines: 1,
        ),
        const SizedBox(width: AppSpacing.sm),
        const _LabelLine(),
      ],
    );
  }
}

class _LabelLine extends StatelessWidget {
  const _LabelLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.onboardingSectionLabelLineWidth,
      height: AppSizes.hairline,
      color: AppColors.dividerOnDark,
    );
  }
}
