import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/age_range_option.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/gender_avatar_option.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/reading_preferences_cubit.dart';
import '../../application/reading_preferences_state.dart';

class ReadingPreferencesPage extends StatelessWidget {
  const ReadingPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '偏好设置',
          onBack: AppRouter.pop,
        ),
        body: BlocBuilder<ReadingPreferencesCubit, ReadingPreferencesState>(
          builder: (context, state) {
            final cubit = context.read<ReadingPreferencesCubit>();

            return ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppLayout.chromeTopHeight(context) + AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              children: [
                AppText(
                  '选择你的性别年龄\n让点点更了解你的喜好',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textOnDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                _SectionLabel(label: '选择性别'),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _GenderCard(
                        gender: ReadingPreferenceGender.female,
                        selected:
                            state.gender == ReadingPreferenceGender.female,
                        onTap: () =>
                            cubit.selectGender(ReadingPreferenceGender.female),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _GenderCard(
                        gender: ReadingPreferenceGender.male,
                        selected: state.gender == ReadingPreferenceGender.male,
                        onTap: () =>
                            cubit.selectGender(ReadingPreferenceGender.male),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                _SectionLabel(label: '选择年龄'),
                const SizedBox(height: AppSpacing.md),
                for (final age in ReadingPreferenceAge.values) ...[
                  AgeRangeOption(
                    label: age.label,
                    selected: state.age == age,
                    onTap: () => cubit.selectAge(age),
                  ),
                  if (age != ReadingPreferenceAge.values.last)
                    const SizedBox(height: AppSpacing.sm),
                ],
                const SizedBox(height: AppSpacing.xxl),
                AppButton(
                  label: '保存',
                  variant: AppButtonVariant.accent,
                  isExpanded: true,
                  onPressed: AppRouter.pop,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppText(
      '— $label —',
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textOnDark),
      textAlign: TextAlign.center,
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.gender,
    required this.selected,
    required this.onTap,
  });

  final ReadingPreferenceGender gender;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFemale = gender == ReadingPreferenceGender.female;
    return GenderAvatarOption(
      label: gender.label,
      activeAsset: isFemale
          ? 'assets/images/onboarding/gender_female_active.png'
          : 'assets/images/onboarding/gender_male_active.png',
      inactiveAsset: isFemale
          ? 'assets/images/onboarding/gender_female_inactive.png'
          : 'assets/images/onboarding/gender_male_inactive.png',
      selected: selected,
      onTap: onTap,
    );
  }
}

