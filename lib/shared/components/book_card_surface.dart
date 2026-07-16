import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Level 2 — 网格书卡卡面底：为「封面 + 文本」整体铺一层卡片背景。
///
/// 卡面色走语义 [AppColors.surfaceCard]（浅色主题=白面，深色主题=深灰面），
/// 三主题经既有 `_isLight` 分支自然解析；圆角/内边距复用全局 token，样式单一真源在此。
class BookCardSurface extends StatelessWidget {
  const BookCardSurface({super.key, required this.child});

  final Widget child;

  /// 卡面内边距（封面/文本与卡边留白），供网格高度换算复用。
  static const double padding = AppSpacing.xs;

  /// 卡面圆角。
  static const double radius = AppRadius.md;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
