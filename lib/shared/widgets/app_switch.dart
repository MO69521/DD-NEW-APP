import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';

/// L1 — 深色 UI 通用开关。
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        width: AppSizes.appSwitchWidth,
        height: AppSizes.appSwitchHeight,
        padding: const EdgeInsets.all(AppSizes.appSwitchInset),
        decoration: BoxDecoration(
          color: value ? AppColors.accentYellow : AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: AnimatedAlign(
          duration: AppDurations.fast,
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: SizedBox(
            width: AppSizes.appSwitchThumbSize,
            height: AppSizes.appSwitchThumbSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: value ? AppColors.textPrimary : AppColors.textOnDark,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
