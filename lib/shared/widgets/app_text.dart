import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

/// Level 1 — 原子文字组件。
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.style = AppTextStyles.bodyLarge,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final TextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
