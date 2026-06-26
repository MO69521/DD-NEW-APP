import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 续费提示文案（随选中套餐变化），如「首月仅要4.9元，到期按8.8元自动续费」。
class MembershipRenewHint extends StatelessWidget {
  const MembershipRenewHint({super.key, required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        hint,
        style: AppTextStyles.membershipRenewHint.copyWith(
          color: AppColors.textOnDarkMuted,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// L3 — 续费提示占位：无文案时高度收拢，下方内容平滑上移。
class MembershipRenewHintSlot extends StatelessWidget {
  const MembershipRenewHintSlot({super.key, this.hint});

  final String? hint;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.hardEdge,
      child: hint == null
          ? const SizedBox(width: double.infinity)
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedSwitcher(
                  duration: AppDurations.fast,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0, 0.15),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    );

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: MembershipRenewHint(
                    key: ValueKey<String>(hint!),
                    hint: hint!,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
    );
  }
}
