import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// Level 3 — home feature 专属组件，禁止放入 shared。
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.appName, required this.tagline});

  final String appName;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(appName, style: AppTextStyles.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        AppText(tagline),
      ],
    );
  }
}
