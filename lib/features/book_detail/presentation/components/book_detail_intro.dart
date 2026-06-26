import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// 作品简介区块（Figma 185:2438）。
class BookDetailIntro extends StatelessWidget {
  const BookDetailIntro({super.key, required this.intro});

  final String intro;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText('作品简介', style: AppTextStyles.bookDetailBlockTitle),
        const SizedBox(height: AppSpacing.sm),
        AppText(intro, style: AppTextStyles.bookDetailIntroBody),
      ],
    );
  }
}
