import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/section_header.dart';
import '../../../../shared/widgets/app_pressable.dart';

/// 目录入口：简介下方横排，无卡片垫底 / 内边距。
class BookDetailCatalogEntry extends StatelessWidget {
  const BookDetailCatalogEntry({
    super.key,
    required this.serialStatus,
    this.onTap,
  });

  final String serialStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: SectionHeader(
        title: '目录',
        titleStyle: AppTextStyles.bookDetailBlockTitle,
        actionLabel: serialStatus,
      ),
    );
  }
}
